this.ijirok_3_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_3";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Alors que vous campez dans le désert du nord, une silhouette s'approche, un noir plat dont l'apparence semble avoir été taillée dans l'air même. Alors qu'elle s'approche, une lueur orange jaillit d'une corne de feu. Les membres de la compagnie sortent leurs armes, car quelle ombre pourrait bien se trouver ici, dans tout ce néant ? Quelle \"chose\" traverse une terre aussi misérable ? Mais on découvre que ce n'est qu'un vieil homme au crâne chauve et au nez rouge et bulbeux. Si la neige pouvait sculpter l'homme dans le granit, ce serait l'aspect de sa création. L'étranger traverse le camp, la compagnie se tourne vers lui et crie, mais pas un seul mercenaire ne s'approche de lui. Il finit par se pencher et poser sa corne sur le sol et la neige éteint son feu. Puis il se lève et continue sa route et disparaît bientôt dans le brouillard de la nuit.\n\n%randombrother% ramasse la corne et la renverse. Une rose en tombe et il est clair, même dans l'obscurité, que les pétales sont douces, mais déjà recroquevillés par le froid brutal. Vous regardez autour de vous à la recherche du vieil homme et voyez ses traces encore fraîches dans la poudreuse.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Toutes sortes de choses étranges dans ces régions désolées.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 3);
						local locations = this.World.EntityManager.getLocations();

						foreach( v in locations )
						{
							if (v.getTypeID() == "location.icy_cave_location")
							{
								this.Const.World.Common.addFootprintsFromTo(this.World.State.getPlayer().getTile(), v.getTile(), this.Const.GenericFootprints, 0.5);
								break;
							}
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") == 0 || this.World.Flags.get("IjirokStage") >= 4)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow || currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 10)
			{
				return;
			}
		}

		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.icy_cave_location")
			{
				if (v.getTile().getDistanceTo(currentTile) > 10)
				{
					return;
				}
			}
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

