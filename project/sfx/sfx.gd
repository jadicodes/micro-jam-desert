class_name Sfx
extends Node

func play_bones_got_sound():
	$BonesGotSound.play()


func play_sad_customer_sound():
	$DissapointedCustomerSound.play()


func play_desert_song():
	$DesertSong.play()


func play_market_song():
	$MarketSong.play()


func fade_to_market_music():
	play_market_song()
	$AnimationPlayer.play("fade_to_market")


func fade_to_desert_music():
	play_desert_song()
	$AnimationPlayer.play("fade_to_desert")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_market":
		$DesertSong.stop()
	if anim_name == "fade_to_desert":
		$MarketSong.stop()
