this.black_book_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.black_book";
		this.m.Name = "The Black Book";
		this.m.Description = "An old and eerie looking tome with a fleshen cover. Its pages are filled with inscrutable writing and mysterious drawings that you can\'t begin to understand. The longer you look at the book, the more uneasy it makes you feel. Perhaps someone with more knowledge in ancient languages could make some sense of it.";
		this.m.Icon = "misc/inventory_necronomicon.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

});

