this.undead_plague_or_infected_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.undead_plague_or_infected";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]Vous croisez un groupe de paysans assis au bord du chemin. Hommes, femmes, enfants. Des vêtements sales, des bottes boueuses, des plaies sur la peau. Quelques-uns portent des blessures en forme de morsures. L\'aîné du groupe prend la parole.%SPEECH_ON%S\'il vous plaît, monsieur, avez-vous de la nourriture ou de l\'eau à nous donner ?%SPEECH_OFF%Il semble vous voir observer les pustules et les morsures. Il secoue la tête.%SPEECH_ON%Oh, ne vous en faites pas. La chasse au renard qui a mal tourné. Nous pourrions juste avoir besoin d\'un peu d\'aide et ensuite nous pourrons reprendre notre chemin.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous pouvons partager un peu de nourriture.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "Ce n\'est pas notre problème.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Vous ne ferez que grossir les rangs des morts-vivants. Nous ferions mieux de vous achever maintenant.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]Vous ordonnez à ces âmes malades de se rétablir - en ordonnant à vos hommes de les tuer tous. L\'aîné emmène les femmes et les enfants tandis que les hommes se lèvent pour défendre leur position. L\'un, vacillant sur des jambes vertes et qui pèlent, te pointe du doigt.%SPEECH_ON%Quel saint tu es connard. J\'espère que je reviendrai d\'entre les morts. J\'espère que mon cadavre vous tuera tous, vous les putain d\'sauvages.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'ai hâte de te tuer deux fois, alors.",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.PeasantsArmed, this.Math.rand(50, 100), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_59.png[/img]Vous dites à %randombrother% de distribuer de la nourriture et des fournitures. L\'aîné vous remercie et dit qu\'il fera l\'éloge de %companyname% partout où il ira. Quelques-uns des hommes semblent soulagés que vous ne leur ayez pas demandé quelque chose d\'horrible.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous faisons ce que nous pouvons.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local food = this.World.Assets.getFoodItems();

				for( local i = 0; i < 2; i = ++i )
				{
					local idx = this.Math.rand(0, food.len() - 1);
					local item = food[idx];
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous donnez " + item.getName()
					});
					this.World.Assets.getStash().remove(item);
					food.remove(idx);
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_29.png[/img]Vous dites à %randombrother% de distribuer de la nourriture et des fournitures. L\'aîné vous remercie et dit qu\'il fera l\'éloge de %companyname% partout où il ira. Prenant un morceau de pain, vous vous accroupissez à côté d\'un enfant malade et du père qui le tient. Mais lorsque vous tendez le pain, l\'enfant tourne la tête et mord dans le cou de son père. Tout paysan en assez bonne santé pour se tenir debout le fait et s\'enfuit. Les autres... eh bien, les autres se remettent sur leurs pieds, les visages pâles, les mâchoires relâchées, les yeux rouges d\'une faim furieuse. Vous ordonnez rapidement aux mercenaires de former les rangs.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aucune bonne action ne reste impunie.",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Peasants, this.Math.rand(10, 30), this.Const.Faction.PlayerAnimals);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.ZombiesLight, this.Math.rand(60, 90), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
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
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local food = this.World.Assets.getFoodItems();

		if (food.len() < 3)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = currentTile.getDistanceTo(t.getTile());

			if (d <= 4)
			{
				return;
			}
		}

		this.m.Score = 10;
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

