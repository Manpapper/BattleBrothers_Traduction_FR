this.black_book_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.black_book";
		this.m.Name = "Le livre noir";
		this.m.Description = "Un étrange et vieux grimoire avec une couverture charnue. Ses pages sont remplies d\'écritures impénétrables et de dessins mystérieux que vous ne pouvez pas commencer à comprendre. Plus vous regardez le livre, plus vous vous sentez mal à l\'aise. Peut-être que quelqu\'un avec plus de connaissances dans les langues anciennes pourrait y trouver un sens.";
		this.m.Icon = "misc/inventory_necronomicon.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

});

