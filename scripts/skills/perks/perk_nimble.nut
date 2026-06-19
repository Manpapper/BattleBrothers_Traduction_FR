this.perk_nimble <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.nimble";
		this.m.Name = this.Const.Strings.PerkName.Nimble;
		this.m.Icon = "ui/perks/perk_29.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function isHidden()
	{
		local fm = this.Math.floor(this.getChance() * 100);
		return fm >= 100;
	}

	function getDescription()
	{
		return "Aussi agile qu\'un chat ! Ce personnage est capable d\'esquiver partiellement ou de dévier les attaques au dernier moment, les transformant ainsi en coups qui ne font qu\'effleurer la cible. Plus l\'armure est légère, plus vous en tirez profit.";
	}

	function getTooltip()
	{
		local fm = this.Math.round(this.getChance() * 100);
		local tooltip = this.skill.getTooltip();

		if (fm < 100)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Reçoit seulement [color=" + this.Const.UI.Color.PositiveValue + "]" + fm + "%[/color] des dégâts de points de vie des attaques"
			});
		}
		else
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]L\'armure du corps et de la tête de ce personnage est trop lourde pour qu\'il puisse tirer profit de son agilité.[/color]"
			});
		}

		return tooltip;
	}

	function getChance()
	{
		local fat = 0;
		local body = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local head = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Head);

		if (body != null)
		{
			fat = fat + body.getStaminaModifier();
		}

		if (head != null)
		{
			fat = fat + head.getStaminaModifier();
		}

		fat = this.Math.min(0, fat + 15);
		local ret = this.Math.minf(1.0, 1.0 - 0.6 + this.Math.pow(this.Math.abs(fat), 1.23) * 0.01);
		return ret;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		local chance = this.getChance();
		_properties.DamageReceivedRegularMult *= chance;
	}

});

