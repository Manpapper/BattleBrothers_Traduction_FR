this.oath_of_honor_warning <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "special.oath_of_honor_warning";
		this.m.Name = "Combat Honorable !";
		this.m.Icon = "skills/status_effect_160.png";
		this.m.IconMini = "status_effect_160_mini";
		this.m.Description = "Ce personnage a prêté un serment d\'honneur et refuse d\'utiliser l\'arme ou l\'outil à distance actuellement équipé !";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect | this.Const.SkillType.Alert;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onTurnStart()
	{
		if (!this.isHidden())
		{
			this.spawnIcon("status_effect_160", this.getContainer().getActor().getTile());
		}
	}

	function isHidden()
	{
		this.m.IsHidden = true;
		local actor = this.getContainer().getActor();

		if (actor.getSkills().hasSkill("trait.oath_of_honor"))
		{
			local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.RangedWeapon) || item.isItemType(this.Const.Items.ItemType.Tool)))
			{
				this.m.IsHidden = false;
			}

			item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (item != null && (item.isItemType(this.Const.Items.ItemType.RangedWeapon) || item.isItemType(this.Const.Items.ItemType.Tool)))
			{
				this.m.IsHidden = false;
			}
		}

		return this.m.IsHidden;
	}

});

