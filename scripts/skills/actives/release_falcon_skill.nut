this.release_falcon_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null
	},
	function create()
	{
		this.m.ID = "actives.release_falcon";
		this.m.Name = "Release Falcon";
		this.m.Description = "Release your falcon to gain vision of the surrounding 12 tiles for the duration of the current round. Can be used once per battle.";
		this.m.Icon = "skills/active_104.png";
		this.m.IconDisabled = "skills/active_104_sw.png";
		this.m.Overlay = "active_104";
		this.m.SoundOnUse = [
			"sounds/combat/hawk_01.wav",
			"sounds/combat/hawk_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted + 5;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function setItem( _i )
	{
		this.m.Item = this.WeakTableRef(_i);
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
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		return ret;
	}

	function isUsable()
	{
		if (this.m.Item.isReleased() || !this.skill.isUsable())
		{
			return false;
		}

		return true;
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.Item.isReleased();
	}

	function onUse( _user, _targetTile )
	{
		this.m.Item.setReleased(true);
		this.Tactical.queryTilesInRange(_user.getTile(), 1, 12, false, [], this.onQueryTile, _user.getFaction());
		return true;
	}

	function onQueryTile( _tile, _tag )
	{
		_tile.addVisibilityForFaction(_tag);

		if (_tile.IsOccupiedByActor)
		{
			_tile.getEntity().setDiscovered(true);
		}

		if (this.Tactical.TurnSequenceBar.getActiveEntity() != null)
		{
			this.Tactical.TurnSequenceBar.getActiveEntity().updateVisibilityForFaction();
		}
	}

});

