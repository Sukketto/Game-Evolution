class_name Livello extends Node

# Classe che gestisce il livello di gioco
# Attribiuti:
# - categoria: categoria del livello (Casual, Arcade, Platform, Puzzle, Tower Defense)
# - nome: nome del livello
# - descrizione: descrizione del livello
# - comandi: immagini dei comandi del livello
# - sfondo: background della presentazione del livello
# - icona: icona del livello usata in alto a destra durante il gioco
# - scena_successiva: nodo del prossimo livello
# - avanzamento: avanzamento del livello
# - avanzamento_max: avanzamento massimo del livello

# Metodi:
# - _ready(): inizializza il livello
# - show_tutorial(): mostra il tutorial del livello
# - hide_tutorial(): nasconde il tutorial del livello
# - avanza(punti: int): avanza il livello di un certo numero di punti
# - prossimo(): converte il livello nel prossimo livello
# - torna_al_menu(): torna al menu principale

# Segnali:
# - tutorial_clicked(x: int, y: int): emesso quando l'utente preme il tutorial
# - tutorial_closed(): emesso quando l'utente chiude il tutorial
# - tutorial_opened(): emesso quando l'utente apre il tutorial
# - icona_pressed(): emesso quando l'utente preme l'icona del livello
# - prossimo_livello_icona_pressed(): emesso quando l'utente preme l'icona del prossimo livello
# - avanzamento_finito(): emesso quando il livello è completato

####

# Attributi
@export var prossimo_livello: PackedScene = null
@export var avanzamento: int = 0
@export var avanzamento_max: int = 100
@export var menu = "res://menu.tscn"
@export var prossimo_livello_icone: Array[Texture] = [load("res://missing.png")]
# Elementi grafici
@onready var tutorial_ui: Control = $UI/Tutorial
@onready var livello_corrente_ui: Control = $"UI/Livello/Livello Corrente"
@onready var livello_successivo_ui: Control = $"UI/Livello/Livello Successivo"
@onready var livello_successivo_texture: TextureRect = $"UI/Livello/Livello Successivo/Texture"

@onready var avanzamento_ui: ProgressBar = $"UI/Livello/Avanzamento/Barra Avanzamento"
@onready var menu_ui: Control = $UI/Esci

# Metodi
func _ready() -> void:
	# Inizializza il livello
	livello_successivo_texture.texture = prossimo_livello_icone[0]
	avanzamento_ui.max_value = avanzamento_max
	avanzamento_ui.value = avanzamento

	# Connette i segnali
	tutorial_ui.connect("gui_input", on_tutorial_clicked)
	livello_corrente_ui.connect("gui_input", on_icona_pressed)
	livello_successivo_ui.connect("gui_input", on_prossimo_livello_icona_pressed)

	# Mostra il tutorial
	show_tutorial()

func show_tutorial() -> void:
	emit_signal("tutorial_opened")
	# Mostra il tutorial del livello
	# TODO: Animazione di apertura: tutorial_element si espande dalla posizione dell'icona_element fino a coprire tutto lo schermo
	tutorial_ui.show()
	get_tree().paused = true

func hide_tutorial() -> void:
	emit_signal("tutorial_closed")
	# Nasconde il tutorial del livello
	# TODO: animazione
	tutorial_ui.hide()
	get_tree().paused = false

func avanza(punti: int) -> void:
	# Avanza il livello di un certo numero di punti
	avanzamento += punti
	avanzamento_ui.value = avanzamento
	if avanzamento >= avanzamento_max:
		emit_signal("avanzamento_finito")

	# Avanza con le texture dell'icona del prossimo livello
	if prossimo_livello_icone.size() > 0:
		var percentuale = float(min(max(0,avanzamento),avanzamento_max)) / avanzamento_max
		var indice = min(max(0,int(percentuale * prossimo_livello_icone.size())),prossimo_livello_icone.size()-1)
		livello_successivo_texture.texture = prossimo_livello_icone[indice]

	# TODO: animazione e scritta dei punti guadagnati
	
func prossimo() -> void:
	# Converte il livello nel prossimo livello
	if prossimo_livello != null:
		emit_signal("prossimo_livello_icona_pressed")
		get_tree().change_scene_to_packed(prossimo_livello)
		# TODO: animazione scorrimento

func torna_al_menu() -> void:
	# mostra un popup di conferma
	var popup = Popup.new()
	popup.set_title("Torna al menu")
	popup.set_text("Sei sicuro di voler tornare al menu principale?")
	popup.connect("confirmed", conferma_torna_al_menu)
	popup.popup_centered()

func conferma_torna_al_menu() -> void:
	# Torna al menu principale
	get_tree().change_scene(menu)
	# TODO: animazione

# Callback

func on_tutorial_clicked(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			# Emette il segnale tutorial_clicked
			emit_signal("tutorial_clicked", get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
			# Default: nasconde il tutorial
			hide_tutorial()

func on_icona_pressed(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			# Emette il segnale icona_pressed
			emit_signal("icona_pressed")
			# Default: mostra il tutorial
			show_tutorial()

func on_prossimo_livello_icona_pressed(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			# Emette il segnale prossimo_livello_icona_pressed
			emit_signal("prossimo_livello_icona_pressed")
			# Default: aumenta l'avanzamento di 10
			avanza(10)

# Segnali
signal tutorial_clicked(x: int, y: int)
signal tutorial_closed()
signal tutorial_opened()
signal icona_pressed()
signal prossimo_livello_icona_pressed()
signal tutorial_icona_pressed()
signal avanzamento_finito()
	
