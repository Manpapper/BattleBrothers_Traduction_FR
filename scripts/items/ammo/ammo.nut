this.ammo <- this.inherit("scripts/items/item", {
	m = {
		ShowOnCharacter = false,
		ShowQuiver = false,
		Sprite = this.Const.Items.Default.PlayerQuiver,
		IconEmpty = "",
		AmmoType = this.Const.Items.AmmoType.None,
		Ammo = 0.0,
		AmmoMax = 0.0,
		AmmoCost = 1
	},
	function getAmmo()
	{
		return this.m.Ammo;
	}

	function getAmmoMax()
	{
		return this.m.AmmoMax;
	}

	function getAmmoType()
	{
		return this.m.AmmoType;
	}

	function setAmmo( _a )
	{
		this.m.Ammo = _a;
	}

	function getAmmoCost()
	{
		return this.m.AmmoCost;
	}

	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.m.Ammo + "/" + this.m.AmmoMax;
	}

	function getIcon()
	{
		if (this.m.Ammo > 0)
		{
			return this.m.Icon;
		}
		else
		{
			return this.m.IconEmpty;
		}
	}

	function consumeAmmo()
	{
		if (this.getContainer().getActor().isPlayerControlled())
		{
			--this.m.Ammo;
			this.Tactical.Entities.spendAmmo(this.m.AmmoCost);
		}
	}

	function create()
	{
		this.item.create();
		this.m.SlotType = this.Const.ItemSlot.Ammo;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function isDroppedAsLoot()
	{
		return this.item.isDroppedAsLoot() && (this.getCurrentSlotType() != this.Const.ItemSlot.Bag || this.m.LastEquippedByFaction == this.Const.Faction.Player) && (this.m.LastEquippedByFaction == this.Const.Faction.Player || this.Math.rand(1, 100) <= 66);
	}

	function onEquip()
	{
		this.item.onEquip();

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.ShowQuiver = this.m.ShowQuiver;

			if (this.m.ShowQuiver)
			{
				app.Quiver = this.m.Sprite;
			}

			this.getContainer().updateAppearance();
		}

		if (!this.getContainer().getActor().isPlayerControlled())
		{
			this.m.Ammo = this.Math.rand(1, this.Math.max(1, this.m.AmmoMax - 1));
		}
	}

	function onUnequip()
	{
		this.item.onUnequip();

		if (this.m.ShowOnCharacter)
		{
			local app = this.getContainer().getAppearance();
			app.ShowQuiver = false;
			this.getContainer().updateAppearance();
		}
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeU16(this.m.Ammo);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Ammo = _in.readU16();
	}

});

