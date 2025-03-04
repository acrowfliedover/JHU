/*
Developed for JHU 605.668: Computer Gaming Engines

This is free and unencumbered software released into the public domain.
For more information, please refer to <https://unlicense.org>
*/

#ifndef GRAPH_SPRITE_NODE_HPP
#define GRAPH_SPRITE_NODE_HPP

#include "graph/node.hpp"
#include "graph/node_t.hpp"

#include "platform/sdl.h"

namespace cge
{
class SpriteNode : public Node
{
  public:
    SpriteNode();

    ~SpriteNode() = default;

    void init(SceneState &scene_state) override;

    void destroy() override;

    void draw(SceneState &scene_state) override;

    void update(SceneState &scene_state) override;

    SDL_Texture *sdl_texture();

    int width() const;

    int height() const;

    void set_filepath(const std::string &filepath);

    void set_color_mods(const uint8_t mods[3]);
    void set_blend(bool blend);
    void set_blend_alpha(uint8_t alpha);

    void set_top_left(float x, float y);

    void set_top_right(float x, float y);

    void set_bottom_left(float x, float y);

  protected:
    SDL_Texture *texture_;
    int          width_;
    int          height_;
    std::string  filepath_;

    bool    apply_color_mod_;
    uint8_t color_mods_[3];

    bool    apply_blend_;
    uint8_t blend_alpha_;

    SDL_FPoint corners_[3];
};

template <typename... ChildrenTs>
using TextureNodeT = NodeT<TextureNode, ChildrenTs...>;

} // namespace cge

#endif // GRAPH_TEXTURE_NODE_HPP
