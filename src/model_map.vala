/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */
/*
 * Copyright (C) 2011-2015 EasyRPG Project
 *
 * License: https://github.com/EasyRPG/Editor/blob/master/COPYING GPL
 *
 * Authors:
 * - Aitor García (Falc) <aitor.falc@gmail.com>
 * - Sebastian Reichel (sre) <sre@ring0.de>
 */

/**
 * Represents a map object in the editor.
 */
public class Map : Model {
	/**
	 * Map name. Not unique.
	 */
	public string name {get; set; default = "";}

	/**
	 * Map width in tiles.
	 *
	 * Default is 20.
	 */
	public int width {get; set; default = 20;}

	/**
	 * Map height in tiles.
	 *
	 * Default is 15.
	 */
	public int height {get; set; default = 15;}

	/**
	 * Tileset used to design the map.
	 *
	 * TODO: This should be replaced by an int id in the future
	 */
	public string tileset {get; set; default = "";}

	/**
	 * Scroll type of the map.
	 *
	 * 0: No scroll. (Default)
	 * 1: Vertical loop only.
	 * 2: Horizontal loop only.
	 * 3: Both vertical and horizontal.
	 */
	public int scroll_type {get; set; default = 0;}

	/**
	 * Defines whether the map uses a panorama.
	 *
	 * Default is false.
	 */
	public bool panorama_use {get; set; default = false;}

	/**
	 * Panorama filename.
	 *
	 * This property is ignored if panorama_use is false.
	 */
	public string panorama_filename {get; set; default = "";}

	/**
	 * Defines whether the panorama loops horizontally.
	 *
	 * Default is false.
	 */
	public bool panorama_horizontal_loop {get; set; default = false;}

	/**
	 * Defines whether the panorama loops vertically.
	 *
	 * Default is false.
	 */
	public bool panorama_vertical_loop {get; set; default = false;}

	/**
	 * Defines whether the panorama autoscrolls horizontally.
	 *
	 * Default is false.
	 *
	 * This property is ignored if panorama_horizontal_loop is false.
	 */
	public bool panorama_horizontal_autoscroll {get; set; default = false;}

	/**
	 * Horizontal autoscroll speed.
	 *
	 * Default is 0. It must be a number between -8 and 8.
	 *
	 * This property is ignored if panorama_horizontal_loop is false or
	 * panorama_horizontal_autoscroll is true.
	 */
	public int panorama_horizontal_autoscroll_speed {get; set; default = 0;}

	/**
	 * Defines whether the panorama autoscrolls vertically.
	 *
	 * Default is false.
	 *
	 * This property is ignored if panorama_vertical_loop is false.
	 */
	public bool panorama_vertical_autoscroll {get; set; default = false;}

	/**
	 * Vertical autoscroll speed.
	 *
	 * Default is 0. It must be a number between -8 and 8.
	 *
	 * This property is ignored if panorama_vertical_loop is false or
	 * panorama_vertical_autoscroll is true.
	 */
	public int panorama_vertical_autoscroll_speed {get; set; default = 0;}

	/**
	 * BGM type.
	 *
	 * 0: Same as parent map. (Default)
	 * 1: Entrust to event.
	 * 2: Specify.
	 */
	public int bgm_type {get; set; default = 0;}

	/**
	 * BGM filename.
	 *
	 * This property is ignored if bgm_type != 2.
	 */
	public string bgm_filename {get; set; default = "";}

	/**
	 * Backdrop type.
	 *
	 * 0: Same as parent map. (Default)
	 * 1: Entrust to event.
	 * 2: Specify.
	 */
	public int backdrop_type {get; set; default = 0;}

	/**
	 * Backdrop filename.
	 *
	 * This property is ignored if backdrop_type != 2.
	 */
	public string backdrop_filename {get; set; default = "";}

	/**
	 * Teleport type.
	 *
	 * 0: Same as parent map. Unavailable if there is no parent map.
	 * 1: Entrust to event.
	 * 2: Specify.
	 */
	public int teleport_type {get; set;}

	/**
	 * Defines whether teleport is allowed.
	 *
	 * Default is true.
	 *
	 * This property is ignored if teleport_type != 2.
	 */
	public bool teleport_allow {get; set; default = true;}

	/**
	 * Escape type.
	 *
	 * 0: Same as parent map. Unavailable if there is no parent map.
	 * 1: Entrust to event.
	 * 2: Specify.
	 */
	public int escape_type {get; set;}

	/**
	 * Defines whether escape from battle is allowed.
	 *
	 * Default is true.
	 *
	 * This property is ignored if escape_type != 2.
	 */
	public bool escape_allow {get; set; default = true;}

	/**
	 * Save type.
	 *
	 * 0: Same as parent map. Unavailable if there is no parent map.
	 * 1: Entrust to event.
	 * 2: Specify.
	 */
	public int save_type {get; set;}

	/**
	 * Defines whether save is allowed.
	 *
	 * Default is true.
	 *
	 * This property is ignored if save_type != 2.
	 */
	public bool save_allow {get; set; default = true;}

	/**
	 * Model containing layer data.
	 */
	public int[,] lower_layer {get; set;}
	public int[,] upper_layer {get; set;}

	/**
	 * Determines how often a battle will happen.
	 *
	 * Default is 25.
	 */
	public int enemy_encounter_steps {get; set; default = 25;}

	/**
	 * While loading save data, if this element is modified, the event execution
	 * state will be reloaded.
	 */
	public int save_time {get; set;}

	/**
	 * Creates a new map model
	 */
	public Map (string name="") {
		this.lower_layer = new int[this.height, this.width];
		this.upper_layer = new int[this.height, this.width];
		this.name = name;
	}

	/**
	 * Loads the map data from an XmlNode object.
	 *
	 * @param data An XmlNode that contains the map data.
	 */
	public override void load_data (XmlNode? data) {
		string name = "";
		int width = 0;
		int height = 0;
		string tileset = "";
		int scroll_type = 0;
		string panorama_filename = "";
		bool panorama_horizontal_loop = false;
		bool panorama_horizontal_autoscroll = false;
		int panorama_horizontal_autoscroll_speed = 0;
		bool panorama_vertical_loop = false;
		bool panorama_vertical_autoscroll = false;
		int panorama_vertical_autoscroll_speed = 0;
		int bgm_type = 0;
		string bgm_filename = "";
		int backdrop_type = 0;
		string backdrop_filename = "";
		int teleport_type = 0;
		bool teleport_allow = false;
		int escape_type = 0;
		bool escape_allow = false;
		int save_type = 0;
		bool save_allow = false;
		string[] lower_layer_string = {};
		string[] upper_layer_string = {};
		int enemy_encounter_steps = 0;
		int save_time = 0;

		if(data == null) {
			/* TODO: handle this better */
			error ("broken map!");
		}

		XmlNode node = data.children;
		while (node != null) {
			switch (node.name) {
				case "name":
					name = node.content;
					break;
				case "width":
					width = int.parse (node.content);
					break;
				case "height":
					height = int.parse (node.content);
					break;
				case "tileset":
					tileset = node.content;
					break;
				case "scroll_type":
					scroll_type = int.parse (node.content);
					break;
				case "panorama":
					XmlNode panorama = node.children;
					while (panorama != null) {
						switch (panorama.name) {
							case "filename":
								panorama_filename = panorama.content;
								break;
							case "horizontal_loop":
								panorama_horizontal_loop = bool.parse (panorama.content);
								break;
							case "horizontal_autoscroll":
								panorama_horizontal_autoscroll = bool.parse (panorama.content);
								break;
							case "horizontal_autoscroll_speed":
								panorama_horizontal_autoscroll_speed = int.parse (panorama.content);
								break;
							case "vertical_loop":
								panorama_vertical_loop = bool.parse (panorama.content);
								break;
							case "vertical_autoscroll":
								panorama_vertical_autoscroll = bool.parse (panorama.content);
								break;
							case "vertical_autoscroll_speed":
								panorama_vertical_autoscroll_speed = int.parse (panorama.content);
								break;
							default:
								break;
						}
						panorama = panorama.next;
					}
					break;
				case "bgm":
					XmlNode bgm = node.children;
					while (bgm != null) {
						switch (bgm.name) {
							case "type":
								bgm_type = int.parse (bgm.content);
								break;
							case "filename":
								bgm_filename = bgm.content;
								break;
							default:
								break;
						}
						bgm = bgm.next;
					}
					break;
				case "backdrop":
					XmlNode backdrop = node.children;
					while (backdrop != null) {
						switch (backdrop.name) {
							case "type":
								backdrop_type = int.parse (backdrop.content);
								break;
							case "filename":
								backdrop_filename = backdrop.content;
								break;
							default:
								break;
						}
						backdrop = backdrop.next;
					}
					break;
				case "teleport":
					XmlNode teleport = node.children;
					while (teleport != null) {
						switch (teleport.name) {
							case "type":
								teleport_type = int.parse (teleport.content);
								break;
							case "allow":
								teleport_allow = bool.parse (teleport.content);
								break;
							default:
								break;
						}
						teleport = teleport.next;
					}
					break;
				case "escape":
					XmlNode escape = node.children;
					while (escape != null) {
						switch (escape.name) {
							case "type":
								escape_type = int.parse (escape.content);
								break;
							case "allow":
								escape_allow = bool.parse (escape.content);
								break;
							default:
								break;
						}
						escape = escape.next;
					}
					break;
				case "save":
					XmlNode save = node.children;
					while (save != null) {
						switch (save.name) {
							case "type":
								save_type = int.parse (save.content);
								break;
							case "allow":
								save_allow = bool.parse (save.content);
								break;
							default:
								break;
						}
						save = save.next;
					}
					break;
				case "layers":
					XmlNode layers_data = node.children;
					while (layers_data != null) {
						switch (layers_data.name) {
							case "lower":
								lower_layer_string = layers_data.content.split (" ");
								break;
							case "upper":
								upper_layer_string = layers_data.content.split (" ");
								break;
							default:
								break;
						}
						layers_data = layers_data.next;
					}
					break;
				case "enemy_encounter_steps":
					enemy_encounter_steps = int.parse (node.content);
					break;
				case "save_time":
					save_time = int.parse (node.content);
					break;
				default:
					break;
			}
			node = node.next;
		}

		/*
		 * Check the parsed values to make sure they are valid.
		 *
		 * It is not neccessary to modify a property if the parsed value match
		 * the default one or is not valid. Also, some dependent properties
		 * can be ignored if they are not going to be used.
		 */
		this.name = (name == "") ? "Untitled" : name;

		// Set a non-default width only when the parsed value is valid
		if (width > 20) {
			this.width = width;
		}

		// Set a non-default height only when the parsed value is valid
		if (height > 15) {
			this.height = height;
		}

		if (tileset != "") {
			this.tileset = tileset;
		}

		this.scroll_type = (scroll_type < 0) ? 0 : scroll_type;

		// If the map does not use a panorama ignore its related values
		if (panorama_filename != "") {
			this.panorama_use = true;
			this.panorama_filename = panorama_filename;

			this.panorama_horizontal_loop = panorama_horizontal_loop;
			this.panorama_vertical_loop = panorama_vertical_loop;

			// The autoscroll configuration is only needed for panoramas with loop
			if (panorama_horizontal_loop == true) {
				this.panorama_horizontal_autoscroll = panorama_horizontal_autoscroll;

				// The autoscroll speed is only needed for non-autoscroll panoramas
				if (panorama_horizontal_autoscroll == false) {
					this.panorama_horizontal_autoscroll_speed = panorama_horizontal_autoscroll_speed;
				}
			}

			// The autoscroll configuration is only needed for panoramas with loop
			if (panorama_vertical_loop == true) {
				this.panorama_vertical_autoscroll = panorama_vertical_autoscroll;

				// The autoscroll speed is only needed for non-autoscroll panoramas
				if (panorama_vertical_autoscroll == false) {
					this.panorama_vertical_autoscroll_speed = panorama_vertical_autoscroll_speed;
				}
			}
		}

		this.bgm_type = (bgm_type < 0) ? 0 : bgm_type;
		if (bgm_type == 2) {
			// FIXME: check if file exists
			this.bgm_filename = bgm_filename;
		}

		this.backdrop_type = (backdrop_type < 0 ) ? 0 : backdrop_type;
		if (backdrop_type == 2) {
			// FIXME: check if file exists
			this.backdrop_filename = backdrop_filename;
		}

		this.teleport_type = (teleport_type < 0) ? 0 : teleport_type;
		if (teleport_type == 2) {
			this.teleport_allow = teleport_allow;
		}

		this.escape_type = (escape_type < 0) ? 0 : escape_type;
		if (escape_type == 2) {
			this.escape_allow = escape_allow;
		}

		this.save_type = (save_type < 0) ? 0 : save_type;
		if (save_type == 2) {
			this.save_allow = save_allow;
		}

		/*
		 * This is the place where the layer tile_id checks should be made, but
		 * it could be interesting to make them at map rendering time.
		 */
		var lower_layer = new int[height, width];
		var upper_layer = new int[height, width];

		/*
		 * Adjusts the length of the array to the size of the map.
		 *
		 * This will discard any extra tile or create undefined tiles.
		 */
		if (lower_layer_string.length != (width * height)) {
			lower_layer_string.resize (width * height);
		}

		if (upper_layer_string.length != width * height) {
			upper_layer_string.resize (width * height);
		}

		int i = 0;
		int col = 0;
		int row = 0;
		int tile_id = 0;

		/*
		 * Layers are converted from an unidimensional array to a bidimensional one
		 */
		while (i < width * height) {
			col = i % width;
			row = i / width;

			// Lower layer
			if (lower_layer_string[i] == null) {
				tile_id = 0;
			}
			else {
				tile_id = int.parse (lower_layer_string[i]);

				// Tile ids cannot be negative
				if (tile_id < 0) {
					tile_id = 0;
				}
			}

			lower_layer[row, col] = tile_id;

			// Upper layer
			if (upper_layer_string[i] == null) {
				tile_id = 0;
			}
			else {
				tile_id = int.parse (upper_layer_string[i]);

				// Tile ids cannot be negative
				if (tile_id < 0) {
					tile_id = 0;
				}
			}

			upper_layer[row, col] = tile_id;

			i++;
		}

		this.lower_layer = lower_layer;
		this.upper_layer = upper_layer;

		this.enemy_encounter_steps = (enemy_encounter_steps < 0) ? 0 : enemy_encounter_steps;

		this.save_time = (save_time < 0) ? 0 : save_time;
	}

	/**
	 * Saves the map data to an XmlNode object.
	 *
	 * @param data An XmlNode that contains the map data.
	 */
	public override void save_data(out XmlNode data) {
		XmlNode node, sub;
		char* layer_data, pos;

		data = new XmlNode ("map");

		node = new XmlNode ("name");
		node.content = this.name;
		data.add_child (node);

		node = new XmlNode ("width");
		node.content = this.width.to_string ();
		data.add_child (node);

		node = new XmlNode ("height");
		node.content = this.height.to_string ();
		data.add_child (node);

		node = new XmlNode ("tileset");
		node.content = this.tileset;
		data.add_child (node);

		node = new XmlNode ("scroll_type");
		node.content = this.scroll_type.to_string ();
		data.add_child (node);

		var panorama = new XmlNode ("panorama");
		data.add_child (panorama);

		node = new XmlNode ("filename");
		node.content = panorama_filename;
		panorama.add_child (node);

		node = new XmlNode ("horizontal_loop");
		node.content = panorama_horizontal_loop.to_string ();
		panorama.add_child (node);

		node = new XmlNode ("horizontal_autoscroll");
		node.content = panorama_horizontal_autoscroll.to_string ();
		panorama.add_child (node);

		node = new XmlNode ("horizontal_autoscroll_speed");
		node.content = panorama_horizontal_autoscroll_speed.to_string ();
		panorama.add_child (node);

		node = new XmlNode ("vertical_loop");
		node.content = panorama_vertical_loop.to_string ();
		panorama.add_child (node);

		node = new XmlNode ("vertical_autoscroll");
		node.content = panorama_vertical_autoscroll.to_string ();
		panorama.add_child (node);

		node = new XmlNode ("vertical_autoscroll_speed");
		node.content = panorama_vertical_autoscroll_speed.to_string ();
		panorama.add_child (node);

		sub = new XmlNode("bgm");
		data.add_child (sub);

		node = new XmlNode ("type");
		node.content = bgm_type.to_string ();
		sub.add_child (node);

		node = new XmlNode ("filename");
		node.content = bgm_filename;
		sub.add_child (node);

		sub = new XmlNode("backdrop");
		data.add_child (sub);

		node = new XmlNode ("type");
		node.content = backdrop_type.to_string ();
		sub.add_child (node);

		node = new XmlNode ("filename");
		node.content = backdrop_filename;
		sub.add_child (node);

		sub = new XmlNode("teleport");
		data.add_child (sub);

		node = new XmlNode ("type");
		node.content = teleport_type.to_string ();
		sub.add_child (node);

		node = new XmlNode ("allow");
		node.content = teleport_allow.to_string ();
		sub.add_child (node);

		sub = new XmlNode("escape");
		data.add_child (sub);

		node = new XmlNode ("type");
		node.content = escape_type.to_string ();
		sub.add_child (node);

		node = new XmlNode ("allow");
		node.content = escape_allow.to_string ();
		sub.add_child (node);

		sub = new XmlNode("save");
		data.add_child (sub);

		node = new XmlNode ("type");
		node.content = save_type.to_string ();
		sub.add_child (node);

		node = new XmlNode ("allow");
		node.content = save_allow.to_string ();
		sub.add_child (node);

		sub = new XmlNode("layers");
		data.add_child (sub);

		node = new XmlNode ("lower");
		layer_data = new char[lower_layer.length[0] * lower_layer.length[1] * 10 + 1];
		pos = layer_data;
		for (int y = 0; y < lower_layer.length[0]; y++) {
			for (int x = 0; x < lower_layer.length[1]; x++) {
				string str = "%d ".printf (lower_layer[y,x]);
				Memory.copy (pos, str, str.length);
				pos += str.length;
			}
		}
		*(pos-1) = '\0';
		node.content = (string) layer_data;
		sub.add_child (node);

		node = new XmlNode ("upper");
		layer_data = new char[lower_layer.length[0] * lower_layer.length[1] * 10 + 1];
		pos = layer_data;
		for (int y = 0; y < upper_layer.length[0]; y++) {
			for (int x = 0; x < upper_layer.length[1]; x++) {
				string str = "%d ".printf (upper_layer[y,x]);
				Memory.copy (pos, str, str.length);
				pos += str.length;
			}
		}
		*(pos-1) = '\0';
		node.content = (string) layer_data;
		sub.add_child (node);

		node = new XmlNode ("enemy_encounter_steps");
		node.content = enemy_encounter_steps.to_string ();
		data.add_child (node);

		node = new XmlNode ("save_time");
		node.content = save_time.to_string ();
		data.add_child (node);
	}

	public void set_size(int width, int height) requires (width > 1 && width < 500) requires (height > 1 && height < 500) {
		/* no change needed */
		if(this.width == width && this.height == height)
			return;

		/* new layer */
		var lower_layer = new int[height, width];
		var upper_layer = new int[height, width];

		/* get bounding box for map copy */
		var small_width  = this.width > width ? width : this.width;
		var small_height = this.height > height ? height : this.height;

		/* copy old map data */
		for (int y = 0; y < small_height; y++) {
			for (int x = 0; x < small_width; x++) {
				lower_layer[y, x] = this.lower_layer[y, x];
				upper_layer[y, x] = this.upper_layer[y, x];
			}
		}

		/* set new size */
		this.width = width;
		this.height = height;

		/* set new map data */
		this.lower_layer = lower_layer;
		this.upper_layer = upper_layer;
	}

	public void shift(Direction dir, int amount) {
		// fix amount to be within valid values (range [0 .. <width or height> - 1])
		bool negative = false;
		if (amount < 0) {
			amount = -amount;
			negative = true;
		}
		int max;
		if (dir == Direction.RIGHT || dir == Direction.LEFT) {
			max = this.width;
		} else {
			max = this.height;
		}
		amount = amount % max;
		if (negative) {
			amount = (max - amount) % max;
		}
		if (amount < 1) {
			return;
		}
		// reversal algorithm
		int p;
		switch (dir) {
			case Direction.RIGHT:
				p = this.width - amount;
				reverse_columns(0, p - 1);
				reverse_columns(p, this.width - 1);
				reverse_columns(0, this.width - 1);
				break;
			case Direction.LEFT:
				p = amount;
				reverse_columns(0, p - 1);
				reverse_columns(p, this.width - 1);
				reverse_columns(0, this.width - 1);
				break;
			case Direction.UP:
				p = amount;
				reverse_rows(0, p - 1);
				reverse_rows(p, this.height - 1);
				reverse_rows(0, this.height - 1);
				break;
			case Direction.DOWN:
				p = this.height - amount;
				reverse_rows(0, p - 1);
				reverse_rows(p, this.height - 1);
				reverse_rows(0, this.height - 1);
				break;
			default:
				warning ("Map Shift: Direction %s not supported!", dir.to_string());
				break;
		}
	}

	private void reverse_rows(int first, int last) {
		if (first == last) {
			return;
		}
		int mid = (last - first - 1) / 2;
		for (int i = 0; i <= mid; i++) {
			// swap rows
			int row1 = first + i;
			int row2 = last - i;
			for (int x = 0; x < this.width; x++) {
				swap(x, row1, x, row2);
			}
		}
	}

	private void reverse_columns(int first, int last) {
		if (first == last) {
			return;
		}
		int mid = (last - first - 1) / 2;
		for (int i = 0; i <= mid; i++) {
			// swap columns
			int col1 = first + i;
			int col2 = last - i;
			for (int y = 0; y < this.height; y++) {
				swap(col1, y, col2, y);
			}
		}
	}

	private void swap(int x1, int y1, int x2, int y2) {
		int tmp;

		tmp = this.lower_layer[y1,x1];
		this.lower_layer[y1,x1] = this.lower_layer[y2,x2];
		this.lower_layer[y2,x2] = tmp;

		tmp = this.upper_layer[y1,x1];
		this.upper_layer[y1,x1] = this.upper_layer[y2,x2];
		this.upper_layer[y2,x2] = tmp;
	}

	/**
	 * Prints the map data.
	 */
	public void print_data () {
		print ("********************************\n");
		print ("MAP DATA\n");
		print ("********************************\n");
		print ("Name: %s\n", this.name);
		print ("Width: %i\n", this.width);
		print ("Height: %i\n", this.height);
		print ("Tileset: %s\n", this.tileset);
		print ("Scroll type: %i\n", this.scroll_type);
		print ("Panorama:\n");
		print ("  Filename: %s\n", this.panorama_filename);
		print ("  Horz loop: %s\n", (this.panorama_horizontal_loop == true) ? "TRUE" : "FALSE");
		print ("  Horz autoscroll: %s\n", (this.panorama_horizontal_autoscroll == true) ? "TRUE" : "FALSE");
		print ("  Horz autoscroll speed: %i\n", this.panorama_horizontal_autoscroll_speed);
		print ("  Vert loop: %s\n", (this.panorama_vertical_loop == true) ? "TRUE" : "FALSE");
		print ("  Vert autoscroll: %s\n", (this.panorama_vertical_autoscroll == true) ? "TRUE" : "FALSE");
		print ("  Vert autoscroll speed: %i\n", this.panorama_vertical_autoscroll_speed);
		print ("BGM type: %i\n", this.bgm_type);
		print ("BGM filename: %s\n", this.bgm_filename);
		print ("Backdrop type: %i\n", this.backdrop_type);
		print ("Backdrop filename: %s\n", this.backdrop_filename);
		print ("Teleport type: %i\n", this.teleport_type);
		print ("Teleport allowed: %s\n", (this.teleport_allow == true) ? "TRUE" : "FALSE");
		print ("Escape type: %i\n", this.escape_type);
		print ("Escape allowed: %s\n", (this.escape_allow == true) ? "TRUE" : "FALSE");
		print ("Save type: %i\n", this.save_type);
		print ("Save allowed: %s\n", (this.save_allow == true) ? "TRUE" : "FALSE");
		print ("Lower layer:");
		int i = 0;
		while (i < lower_layer.length[0] * lower_layer.length[1]) {
			if (i % lower_layer.length[1] == 0) {
				print ("\n");
			}
			print ("%i ", lower_layer[i / lower_layer.length[1], i % lower_layer.length[1]]);
			i++;
		}
		i = 0;
		print ("\nUpper layer:");
		while (i < upper_layer.length[0] * upper_layer.length[1]) {
			if (i % upper_layer.length[1] == 0) {
				print ("\n");
			}
			print ("%i ", upper_layer[i / upper_layer.length[1], i % upper_layer.length[1]]);
			i++;
		}
		print ("\nEnemy encounter steps: %i\n", this.enemy_encounter_steps);
		print ("Save time: %i\n\n", this.save_time);
	}
}
