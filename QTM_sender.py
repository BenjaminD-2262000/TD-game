import asyncio
import qtm_rt
import xml.etree.ElementTree as ET
import socket

marker_labels = []

GODOT_HOST = '127.0.0.1'
GODOT_PORT = 4242

# Track which markers were already raised
knee_above_threshold = {}
HEIGHT_THRESHOLD = 600  # mm

def on_packet(packet):
    """Callback function called every time a data packet arrives from QTM"""
    header, markers = packet.get_3d_markers()

    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        for i, marker in enumerate(markers):
            label = marker_labels[i] if i < len(marker_labels) else f"Marker {i+1}"

            if "Knee" in label:
                z = marker[2]
                was_above = knee_above_threshold.get(label, False)

                if z > HEIGHT_THRESHOLD and not was_above:
                    # Knee just rose above threshold → send step
                    msg = "step"
                    print(msg)
                    sock.sendto(msg.encode(), (GODOT_HOST, GODOT_PORT))
                    knee_above_threshold[label] = True

                elif z <= HEIGHT_THRESHOLD and was_above:
                    # Knee dropped below threshold → reset state
                    knee_above_threshold[label] = False

async def main():
    global marker_labels
    connection = await qtm_rt.connect("127.0.0.1")

    if connection is None:
        print("Failed to connect to QTM.")
        return

    
    while not marker_labels:
        # Get marker labels
        xml = await connection.get_parameters(parameters=["3d"])
        root = ET.fromstring(xml)

        marker_labels = [name.text for name in root.findall(".//Label/Name")]


    # Initialize knee state tracking
    for label in marker_labels:
        if "Knee" in label:
            knee_above_threshold[label] = False

    # Start streaming only after labels are set
    await connection.stream_frames(components=["3d"], on_packet=on_packet)
    await asyncio.Future()  # Run forever

if __name__ == "__main__":
    asyncio.run(main())
