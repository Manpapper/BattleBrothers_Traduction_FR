this.weapon_breaking_warning <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "special.weapon_breaking_warning";
		this.m.Name = "Weapon in poor condition!";
		this.m.Icon = "skills/status_effect_59.png";
		this.m.IconMini = "status_effect_59_mini";
		this.m.Description = "L\'arme de ce personnage est en mauvais état et peut se briser définitivement si elle est réutilisée.";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect | this.Const.SkillType.Alert;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function getDescription()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (!this.m.IsHidden && item != null)
		{
			local p = this.Math.floor(100 * item.getCondition() / item.getConditionMax());
			return "L\'arme de ce personnage est en mauvais état. (" + p + "%) et peut se briser définitivement s\'il est réutilisé.";
		}
		else
		{
			return this.m.Description;
		}
	}

	function onTurnStart()
	{
		if (!this.isHidden())
		{
			this.spawnIcon("status_effect_59", this.getContainer().getActor().getTile());
		}
	}

	function isHidden()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item == null || item.getConditionMax() <= 1.0 || item.getCondition() > this.Const.Combat.AlertWeaponBreakingCondition)
		{
			this.m.IsHidden = true;
		}
		else
		{
			this.m.IsHidden = false;
		}

		return this.m.IsHidden;
	}

});

