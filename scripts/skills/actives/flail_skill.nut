this.flail_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.flail";
		this.m.Name = "Fouetter";
		this.m.Description = "Fouetter un ennemi. Quelque peu imprévisible au niveau des dégâts, mais permet de frapper par dessus ou de contourner le bouclier.";
		this.m.KilledString = "Ecrasé";
		this.m.Icon = "skills/active_39.png";
		this.m.IconDisabled = "skills/active_39_sw.png";
		this.m.Overlay = "active_39";
		this.m.SoundOnUse = [
			"sounds/combat/flail_01.wav",
			"sounds/combat/flail_02.wav",
			"sounds/combat/flail_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/flail_hit_01.wav",
			"sounds/combat/flail_hit_02.wav",
			"sounds/combat/flail_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsShieldRelevant = false;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 13;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 50;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ignore le bonus de Défense en Mêlée donné par les boucliers"
			}
		]);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInFlails ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectChop);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});

