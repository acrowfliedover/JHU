/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#ifndef TIME_MANAGER_HPP
#define TIME_MANAGER_HPP
#include <chrono>

namespace cge
{
class TimeManager
{
  public:
    TimeManager() : startTime(std::chrono::high_resolution_clock::now()) {}

    ~TimeManager() = default;
    float get_current_time();

    void update_last_update_time(float update_interval);

    void update_last_draw_time(float draw_interval);

    bool update_scene(float update_interval);
    bool draw_scene(float draw_interval);

  private:
    float last_update_time = 0.0;
    float last_draw_time = 0.0;
    std::chrono::high_resolution_clock::time_point startTime;
 
};

} // namespace cge

#endif // GRAPH_NODE_HPP
