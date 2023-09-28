const std = @import("std");
const components = @import("components.zig");

pub const Entity = struct {
    id: i32,
};

pub const Scene = struct {
    entities: std.ArrayList(Entity),
    cameras: std.ArrayList(?components.CameraComponent),
    sprites: std.ArrayList(?components.SpriteComponent),
    movements: std.ArrayList(?components.MovementComponent),
    transforms: std.ArrayList(?components.TransformComponent),
};

pub fn initScene() Scene {
    const allocator = std.heap.page_allocator;
    return Scene{
        .entities = std.ArrayList(Entity).init(allocator),
        .cameras = std.ArrayList(?components.CameraComponent).init(allocator),
        .sprites = std.ArrayList(?components.SpriteComponent).init(allocator),
        .movements = std.ArrayList(?components.MovementComponent).init(allocator),
        .transforms = std.ArrayList(?components.TransformComponent).init(allocator),
    };
}

pub fn deinitScene(scene: *Scene) void {
    scene.entities.deinit();
    scene.cameras.deinit();
    scene.sprites.deinit();
    scene.movements.deinit();
    scene.transforms.deinit();
}
