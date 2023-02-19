const CLOSENESS_TO_GO_TO_OBJECT : int = 150;
const MAX_SIZE : Vector2 = Vector2(1, 1);
const MAX_SPEED : int = 2000;
const MIN_SCALE : float = 0.7;
const MIN_SIZE : Vector2 = Vector2(MIN_SCALE, MIN_SCALE);
const MOVEMENT_SPEED : int = 12;
const ROTATION_SCALE : float = 1.0 / 20;
const SCALE_VECTOR : Vector2 = Vector2(5, 5);

static func towards_mouse(card : GameplayCard, delta : float):
	towards(card, card.get_global_mouse_position(), delta, true);
	change_size(card, delta, false);

static func towards(card : GameplayCard, target_position : Vector2, delta : float, do_rotate : bool = false):
	var position : Vector2 = card.position;
	var distance : float = position.distance_to(target_position);
	if card.do_teleport:
		card.position = target_position;
		stop_teleport(card);
		return;
	card.position = position.move_toward(target_position, min(MOVEMENT_SPEED * distance, MAX_SPEED) * delta);
	release_go_to_position(card);
	rotate(card, position, do_rotate, delta);

static func stop_teleport(card : GameplayCard):
	if card.point_teleport:
		card.stop_teleport();

static func change_size(card : GameplayCard, delta : float, to_bigger : bool = true):
	var direction : int = -1;
	var max_size : Vector2 = MAX_SIZE;
	if card.max_slot > 4:
		max_size -= Vector2(0.125, 0.125);
	if to_bigger:
		direction = 1;
	card.scale += direction * SCALE_VECTOR * delta;
	card.scale = System.Scale.vectors(card.scale, MIN_SIZE, max_size);

static func rotate(card : GameplayCard, original_position : Vector2, do_rotate : bool, delta : float):
	if do_rotate:
		card.rotation_degrees += ROTATION_SCALE * (card.position.x - original_position.x);
	else:
		card.rotation_degrees = System.Scale.baseline(card.rotation_degrees, delta);

static func release_go_to_position(card : GameplayCard):
	if System.Vectors.is_same(card.position, card.go_to_positions[0], CLOSENESS_TO_GO_TO_OBJECT):
		card.go_to_positions[0] = System.Vectors.default();
		if card.go_to_positions.size() > 1:
			card.go_to_positions.remove(0);
