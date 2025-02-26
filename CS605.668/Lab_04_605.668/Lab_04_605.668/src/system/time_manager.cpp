#include "system/time_manager.hpp"

namespace cge
{

 float TimeManager::get_current_time()
    {
        auto now = std::chrono::high_resolution_clock::now();
        auto duration = now - startTime; 
        return std::chrono::duration<float>(duration).count();
    }

    void TimeManager::update_last_update_time(float update_interval)
    {
        last_update_time += update_interval;
    }

    void TimeManager::update_last_draw_time(float draw_interval)
    {
        last_draw_time += draw_interval;
    }

    bool TimeManager::update_scene(float update_interval)
    {
        float current_time = get_current_time();
        float elasted_time = current_time - last_update_time;
        if(elasted_time >= update_interval)
        { 
            update_last_update_time(update_interval);
            return true;
        }
        return false;
    }

    bool TimeManager::draw_scene(float draw_interval)
    {
        float current_time = get_current_time();
        float elasted_time = current_time - last_draw_time;
        if(elasted_time >= draw_interval)
        {
            update_last_draw_time(draw_interval);
            return true;
        }
        return false;
    }

} // namespace cge
