this.no_ammo_warning <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "special.no_ammo_warning";
		this.m.Name = "No Ammunition!";
		this.m.Icon = "skills/status_effect_63.png";
		this.m.IconMini = "status_effect_63_mini";
		this.m.Description = "Ce personnage n\'a plus de munitions pour l\'arme à distance actuellement équipée !";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect | this.Const.SkillType.Alert;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onTurnStart()
	{
		if (!this.isHidden())
		{
			this.spawnIcon("status_effect_63", this.getContainer().getActor().getTile());
		}
	}

	function isHidden()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		this.m.IsHidden = true;

		if (item != null && item.isItemType(this.Const.Items.ItemType.RangedWeapon) && (item.getAmmoID() != "" || item.isItemType(this.Const.Items.ItemType.Ammo)))
		{
			if (item.getAmmoMax() == 0)
			{
				local ammo = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);

				if (ammo == null || ammo.getID() != item.getAmmoID() || ammo.getAmmo() == 0)
				{
					this.m.IsHidden = false;
				}
			}
			else if (item.getAmmo() == 0)
			{
				this.m.IsHidden = false;
			}
		}

		return this.m.IsHidden;
	}

});

