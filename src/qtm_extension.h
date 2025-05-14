#ifndef QTM_EXTENSION_H
#define QTM_EXTENSION_H

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <thread>
#include <atomic>

namespace godot {

    class QTMExtension : public Node3D {
        GDCLASS(QTMExtension, Node3D);

    private:
        std::thread worker_thread;
        std::atomic<bool> running;
        Vector3 current_position;

    public:
        QTMExtension();
        ~QTMExtension();

        virtual void _process(double delta) override;
        void _ready();

        Vector3 get_qtm_position() const;

        void start_qtm_stream();
        void stop_qtm_stream();
        void qtm_loop(); // will use Qualisys SDK
    };

}

#endif