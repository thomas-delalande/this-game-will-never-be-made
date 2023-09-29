const std = @import("std");
const components = @import("components.zig");

pub const Entity = struct {
    id: i32,
};

pub const Scene = struct {
    counter: i32,
    entities: std.ArrayList(Entity),
    cameras: std.ArrayList(?components.CameraComponent),
    sprites: std.ArrayList(?components.SpriteComponent),
    movements: std.ArrayList(?components.MovementComponent),
    transforms: std.ArrayList(?components.TransformComponent),
    randomWalkers: std.ArrayList(?components.RandomWalker),
};

pub fn addEntity(scene: *Scene, camera: ?components.CameraComponent, sprite: ?components.SpriteComponent, movement: ?components.MovementComponent, transform: ?components.TransformComponent, randomWalker: ?components.RandomWalker) !void {
    try scene.entities.append(.{ .id = scene.counter });
    scene.counter += 1;
    try scene.cameras.append(camera);
    try scene.transforms.append(transform);
    try scene.movements.append(movement);
    try scene.sprites.append(sprite);
    try scene.randomWalkers.append(randomWalker);
}

pub fn initScene() Scene {
    const allocator = std.heap.page_allocator;
    return Scene{ .counter = 0, .entities = std.ArrayList(Entity).init(allocator), .cameras = std.ArrayList(?components.CameraComponent).init(allocator), .sprites = std.ArrayList(?components.SpriteComponent).init(allocator), .movements = std.ArrayList(?components.MovementComponent).init(allocator), .transforms = std.ArrayList(?components.TransformComponent).init(allocator), .randomWalkers = std.ArrayList(?components.RandomWalker).init(allocator) };
}

pub fn deinitScene(scene: *Scene) void {
    scene.entities.deinit();
    scene.cameras.deinit();
    scene.sprites.deinit();
    scene.movements.deinit();
    scene.transforms.deinit();
    scene.randomWalkers.deinit();
}
