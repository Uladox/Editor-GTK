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
 * Represents the party object in the editor.
 */
public class Party : Model {
	/*
	 * Properties
	 */
	public int characters {get; set; default = 0;} // FIXME - Not int, just a temporary type
	public int map_id {get; set; default = 0;}

	/**
	 * Object X coordinate in tile units. Default is 0.
	 */
	public int x {get; set; default = 0;}

	/**
	 * Object Y coordinate in tile units. Default is 0.
	 */
	public int y {get; set; default = 0;}

	/**
	 * Loads the party data from an XmlNode object.
	 *
	 * @param data An XmlNode that contains the party data.
	 */
	public override void load_data (XmlNode? data) {
		int map_id = 0;
		int x = 0;
		int y = 0;

		if (data != null) {
			XmlNode node = data.children;
			while (node != null) {
				switch (node.name) {
					case "map":
						map_id = int.parse (node.content);
						break;
					case "x_coordinate":
						x = int.parse (node.content);
						break;
					case "y_coordinate":
						y = int.parse (node.content);
						break;
					default:
						break;
				}
				node = node.next;
			}
		}

		// Before this, there should be some value/type checking
		this.map_id = map_id;
		this.x = x;
		this.y = y;
	}

	/**
	 * Saves the party data to an XmlNode object.
	 *
	 * @param data An XmlNode that contains the party data.
	 */
	public override void save_data (out XmlNode data) {
		XmlNode node;

		// Root element
		data = new XmlNode("party");

		// Map id
		node = new XmlNode("map");
		node.content = this.map_id.to_string ();
		data.add_child(node);

		// X coordinate
		node = new XmlNode("x_coordinate");
		node.content = this.x.to_string ();
		data.add_child(node);

		// Y coordinate
		node = new XmlNode("y_coordinate");
		node.content = this.y.to_string ();
		data.add_child(node);
	}
}
