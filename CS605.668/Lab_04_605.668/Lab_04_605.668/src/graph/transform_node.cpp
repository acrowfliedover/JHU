/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/
#define _USE_MATH_DEFINES
#include "graph/transform_node.hpp"

#include "graph/texture_node.hpp"

#include <iostream>
#include <cmath>

namespace cge
{

TransformNode::TransformNode() { transform_.set_identity(); }

void TransformNode::init(SceneState &scene_state) { init_children(scene_state); }

void TransformNode::destroy() { 
    destroy_children();
    clear_children(); }

void TransformNode::draw(SceneState &scene_state)
{

    scene_state.matrix_stack->push();
    scene_state.matrix_stack->top() *= transform_;
    draw_children(scene_state);
    scene_state.matrix_stack->pop();
}

void TransformNode::update(SceneState &scene_state) { update_children(scene_state); }

void TransformNode::set_identity() { transform_.set_identity(); }
    
void TransformNode::left_scale(float x, float y) { transform_.left_scale(x, y); }

void TransformNode::right_scale(float x, float y) { transform_.right_scale(x, y); }

void TransformNode::left_rotate_degrees(float angle_deg){transform_.left_rotate(angle_deg * M_PI / 180.0);}

void TransformNode::right_rotate_degrees(float angle_deg){transform_.right_rotate(angle_deg * M_PI / 180.0);}

void TransformNode::left_rotate(float angle_rad){transform_.left_rotate(angle_rad);}

void TransformNode::right_rotate(float angle_rad) { transform_.right_rotate(angle_rad); }


void TransformNode::left_translate(float x, float y) { transform_.left_translate(x,y); }

void TransformNode::right_translate(float x, float y) { transform_.right_translate(x, y); }

} // namespace cge
