this.glorious_endurance_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		DamageReduction = 0.0
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "Endurance Glorieuse ";
		this.m.Icon = "ui/traits/trait_icon_70.png";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getDescription()
	{
		return "Forgé dans les arènes du Sud, ce personnage a combattu beaucoup de batailles, et chaque coup ne fera qu\'augmenter se Détermination inébranlable et son endurance. Son niveau de vie fabuleux demande une grosse paie, mais il ne désertera jamais et ne peut être renvoyé. Si les trois membres du départ meurent la campagne se terminera.";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.m.DamageReduction > 0.0)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Reçoit seulement [color=" + this.Const.UI.Color.PositiveValue + "]" + (1.0 - this.m.DamageReduction) * 100 + "%[/color] de dégâts"
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Gagne [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] de réduction de dommage pour chaque coup reçu, jusqu\'à une limite de [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color]"
		});
		return ret;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_attacker != null && _attacker.getID() != this.getContainer().getActor().getID())
		{
			this.m.DamageReduction = this.Math.minf(0.25, this.m.DamageReduction + 0.05);
			this.m.Type = this.Const.SkillType.Trait | this.Const.SkillType.StatusEffect;
		}
	}

	function onCombatStarted()
	{
		this.m.DamageReduction = 0.0;
		this.m.Type = this.Const.SkillType.Trait;
	}

	function onCombatFinished()
	{
		this.m.DamageReduction = 0.0;
		this.m.Type = this.Const.SkillType.Trait;
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 1.0 - this.m.DamageReduction;
	}

});

