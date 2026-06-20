this.hexe_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.hexe_potion";
		this.m.Name = "Appel de Solidarité";
		this.m.Icon = "skills/status_effect_148.png";
		this.m.IconMini = "status_effect_148_mini";
		this.m.Overlay = "status_effect_148";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ce personnage a quelque chose de particulier. Physiquement, il semble inchangé, mais il dégage pourtant une sorte de sentiment d’angoisse. Tout malheur qui lui arrive, sur le champ de bataille ou en dehors, semble affecter une autre personne à proximité. C’est utile au combat, agaçant au campement, et cela le conduit inévitablement à l’isolement dans la vie quotidienne.";
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
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] des dégâts subis, qui sont répercutés sur l\'attaquant"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "D\'autres mutations entraîneront une durée de maladie plus longue."
			}
		];
		return ret;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0 && _attacker != null && _attacker.isAlive() && _attacker.getHitpoints() > 0 && _attacker.getID() != this.getContainer().getActor().getID() && !_attacker.getCurrentProperties().IsImmuneToDamageReflection)
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = _damageHitpoints;
			hitInfo.DamageArmor = 0.0;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			_attacker.onDamageReceived(_attacker, null, hitInfo);
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isHexePotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isHexePotionAcquired", false);
	}

});

