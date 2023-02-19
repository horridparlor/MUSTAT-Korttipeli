extends NexusContentPage
class_name NexusDeckBuilder

signal save_deck(deck_data);

onready var cards_in_deck : Node2D = $CardsInDeck;
onready var deck : NexusDeckBuilderDeck = $Deck;
onready var collection : NexusDeckBuilderCollection = $Collection;

const MAX_CARDS_VISIBLE : int = 42;
const SLIDING_FLOOR : float = 10.0;
const SLIDING_FRICTION : float = 1.2;
const SLIDE_PICKING_FLOOR : int = 72;
const SLIDING_SPEED : float = 1.8;

var active_deck_slot : int;
var cards_back_collection : Array;
var cards_front_collection : Array;
var deck_storage : Array;
var is_sliding : bool;
var sliding_position : float;
var to_slide : float;

func all_cards():
	return cards_back_collection + card_storage + cards_front_collection;
