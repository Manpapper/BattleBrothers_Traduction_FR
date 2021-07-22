this.glorious_quickness_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "Rapidité Glorieuse";
		this.m.Icon = "ui/traits/trait_icon_71.png";
		this.m.Description = "Forgé dans les arènes du Sud, ce personnage a combattu beaucoup de batailles, et est un expert pour gérer plusieurs ennemis un par un. Son niveau de vie fabuleux demande une grosse paie, mais il ne désertera jamais et ne peut être renvoyé. Si les trois membres du départ meurent la campagne se terminera.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
				text = "En tuant un ennemi durant son tour, ce personnage regagnera immédiatement [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] Point D\'Action"
			}
		];
		return ret;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();

		if (actor.isAlliedWith(_targetEntity))
		{
			return;
		}

		if (actor.getActionPoints() == actor.getActionPointsMax())
		{
			return;
		}

		if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == actor.getID())
		{
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 1));
			actor.setDirty(true);
			this.spawnIcon("trait_icon_71", this.m.Container.getActor().getTile());
		}
	}

});

