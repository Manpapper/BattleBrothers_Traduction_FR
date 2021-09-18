this.bandage_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.bandage";
		this.m.Name = "Bandages";
		this.m.Description = "Clean bandages that can be used in combat to apply pressure to bleeding wounds and stop any hemorrhaging.";
		this.m.SlotType = this.Const.ItemSlot.Bag;
		this.m.IsAllowedInBag = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IconLarge = "";
		this.m.Icon = "consumables/bandages_01.png";
		this.m.StaminaModifier = -2;
		this.m.Value = 25;
	}

	function getTooltip()
	{
		local result = this.accessory.getTooltip();
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local skill = this.new("scripts/skills/actives/bandage_ally_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

	function onPutIntoBag()
	{
		this.onEquip();
	}

});

