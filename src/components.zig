const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));
const common = @import("common.zig");

pub const CameraComponent = struct {};

pub const SpriteComponent = struct {
    texture: r.Texture,
    source: r.Rectangle,
    width: f32,
    height: f32,
    origin: common.Vector2,
};

pub const MovementComponent = struct {
    speed: f32,
};

pub const TransformComponent = struct { position: common.Vector2 };

pub const RandomWalker = struct {};
