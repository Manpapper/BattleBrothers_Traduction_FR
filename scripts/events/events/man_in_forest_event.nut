this.man_in_forest_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.man_in_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Alors qu\'il se faufile entre les arbres, un homme émerge soudainement d\'un des buissons. Les brindilles et les broussailles sont toutes emmêlées dans ses cheveux en sueur. Il se redresse à votre vue.%SPEECH_ON%S\'il vous plaît, arrêtez.%SPEECH_OFF% Vous levez la main pour le calmer puis lui demandez ce qui se passe. L\'étranger recule d\'un pas.%SPEECH_ON%S\'il vous plaît, arrêtez !%SPEECH_OFF%Il se retourne et s\'enfuit en se débattant pour revenir d\'où il est venu. %randombrother% se précipite à vos côtés.%SPEECH_ON% Devrions-nous le suivre?%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Suivons-le, vite !",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 45)
						{
							return "B";
						}
						else if (r <= 90)
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
					Text = "Il n\'est pas notre préoccupation. Laissez-le partir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_50.png[/img]Vous suivez l\'homme dans le fourré. Ses pas boueux ne sont pas difficiles à suivre, sa retraite peu gracieuse laisse beaucoup de traces. Mais soudainement, elles disparaissent. L\'homme est sorti dans une clairière, puis ses traces ont disparu. Vous entendez un sifflement au-dessus de vous. Levant les yeux, vous voyez l\'homme assis sur une branche. Il fait signe de la main.%SPEECH_ON%Bonjour, étrangers.%SPEECH_OFF%Il jette un coup d\'œil à travers la clairière. Des hommes approchent et ils sont bien armés. L\'homme dans l\'arbre s\'ébroue.%SPEECH_ON%Au revoir, étrangers.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux Armes!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BanditTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditDefenders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
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
			Text = "[img]gfx/ui/events/event_25.png[/img]Les traces de l\'homme s\'éloignent dans la hâte qui l\'a si effroyablement forcé à disparaître de votre vue. Un homme effrayé comme lui n\'est pas difficile à trouver, malheureusement il n\'est plus effrayé, car tout ce que vous trouvez de lui est un cadavre complètement éviscéré. Un léger grognement fait vibrer les buissons voisins. Vous regardez pour voir une fourrure noire et lisse sortir lentement de derrière un arbre. Vous criez aux hommes de s\'armer.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux Armes!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Direwolves, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]L\'homme effrayé n\'était pas difficile à trouver. Vous le repérez recroquevillé au pied d\'un arbre. Il serre quelque chose contre sa poitrine comme s\'il cherchait à s\'en réchauffer par une nuit froide. L\'homme lui-même, cependant, est mort. Vous arrachez l\'objet de sa main collante.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce que c\'est ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/named/named_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.SnowyForest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 7;
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

