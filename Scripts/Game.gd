extends Node

# onready var bg_music = $BackgroundMusic

# Wann startet ein Kampf?
# Monster beginnt Angriff -> Monster findet Spieler
# Monster wird getroffen -> beginnt Spielersuche

# Wann endet ein Kampf?
# Wenn die Lister der Encounter abgearbeitet ist.
# Called when the node enters the scene tree for the first time.

func _ready():
    Music.play_song ( "NormalTheme", 1.0 )
    
func _on_encounter_started ( _idx ):
    var enemies = get_tree().get_nodes_in_group ( "mob" )
    for enemy in enemies:
        enemy.connect ( "first_hit", self, "_on_fight_started" )

func _on_fight_started():
    if ( Music.is_song_playing ( "NormalTheme" ) ):
        Music.stop_song ( 5.5 )
    Music.play_song ( "BattleTheme", 5.5 )
    
    
func _on_fight_ended():
    Music.play_song ( "NormalTheme", 1.0 )
    
    
