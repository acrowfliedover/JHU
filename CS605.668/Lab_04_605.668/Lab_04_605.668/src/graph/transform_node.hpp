/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#ifndef GRAPH_TRANSFORM_NODE_HPP
#define GRAPH_TRANSFORM_NODE_HPP

#include "graph/node.hpp"
#include "graph/node_t.hpp"
#include "graph/math.hpp"

namespace cge
{
class TransformNode : public Node
{
  public:
    TransformNode();

    ~TransformNode() = default;

    void init(SceneState &scene_state) override;

    void destroy() override;

    void draw(SceneState &scene_state) override;

    void update(SceneState &scene_state) override;

    void set_identity();

    void left_scale(float x, float y);

    void right_scale(float x, float y);

    void left_rotate_degrees(float angle_deg);

    void right_rotate_degrees(float angle_deg);

    void left_rotate(float angle_rad);

    void right_rotate(float angle_rad);

    void left_translate(float x, float y);

    void right_translate(float x, float y);

  protected:
    Matrix3 transform_;
};

template <typename... ChildrenTs>
using TransformNodeT = NodeT<TransformNode, ChildrenTs...>;

} // namespace cge

#endif // GRAPH_TRANSFORM_NODE_HPP
