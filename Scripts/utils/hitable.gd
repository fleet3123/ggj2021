extends KinematicBody2D

signal took_hit ( from, damage )

func take_hit ( from, damage ):
    emit_signal ( "took_hit", from, damage )
