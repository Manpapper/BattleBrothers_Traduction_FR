this.agent_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.agent";
		this.m.Name = "L\'Agent";
		this.m.Description = "L\'agent a des yeux et des oreilles partout et saura où aller pour un contrat bien rémunéré. Elle sait aussi entretenir de bonnes relations avec les personnes importantes du pays.";
		this.m.Image = "ui/campfire/agent_01";
		this.m.Cost = 4000;
		this.m.Effects = [
			"Révèle les contrats disponibles dans l\'infobulle des colonies, où que vous soyez",
			"Les bonnes relations avec une faction se dégradent plus lentement et les mauvaises relations se rétablissent plus rapidement"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Avoir une relation \"Allié\" avec une maison noble ou une ville-État"
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.RelationDecayGoodMult = 0.9;
		this.World.Assets.m.RelationDecayBadMult = 1.1;
	}

	function onEvaluate()
	{
		local allied = false;
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( n in nobles )
		{
			if (n.getPlayerRelation() >= 90.0)
			{
				this.m.Requirements[0].IsSatisfied = true;
				return;
			}
		}

		local citystates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

		foreach( c in citystates )
		{
			if (c.getPlayerRelation() >= 90.0)
			{
				this.m.Requirements[0].IsSatisfied = true;
				return;
			}
		}
	}

});

