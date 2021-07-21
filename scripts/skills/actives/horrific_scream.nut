this.horrific_scream <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.horrific_scream";
		this.m.Name = "Cri d\'Horreur";
		this.m.Description = "";
		this.m.Icon = "skills/active_41.png";
		this.m.IconDisabled = "skills/active_41.png";
		this.m.Overlay = "active_41";
		this.m.SoundOnUse = [
			"sounds/enemies/horrific_scream_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " utilise Cri d\'Horreur");
		}

		_targetTile.getEntity().checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
		_targetTile.getEntity().checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
		_targetTile.getEntity().checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
		_targetTile.getEntity().checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
		return true;
	}

});

