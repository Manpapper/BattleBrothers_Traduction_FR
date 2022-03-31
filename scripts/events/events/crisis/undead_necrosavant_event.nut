this.undead_necrosavant_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_necrosavant";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Un tas de gravats se dresse sur le côté du chemin. Là, devant elle, un barbu studieux regarde attentivement les pierres. Il est tellement plongé dans ses pensées qu\'il ne le remarquerait probablement pas si vous continuiez simplement à marcher.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons ce qu\'il fait.",
					function getResult( _event )
					{
						if (_event.m.Witchhunter != null)
						{
							if (this.Math.rand(1, 100) <= 50)
							{
								return "B";
							}
							else
							{
								return "D";
							}
						}
						else if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Continuons d\'avancer.",
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
			Text = "[img]gfx/ui/events/event_17.png[/img]Vous n\'allez pas laisser ce pauvre vieux con ici tout seul. Vous vous approchez de lui et lui demandez ce qu\'il fait. Il vous regarde, ce qui doit être au moins soixante-dix hivers ayant altéré sa peau en une grimace coriace et permanente. Il rit.%SPEECH_ON%Essayer de donner un sens à tout cela. Les morts se lèvent de la terre et, vu que je suis sur le point de me traîner vers ma propre tombe d\'un jour à l\'autre, je me suis dit pourquoi ne pas être sûr que je ne suis pas du genre à rejoindre leurs rangs ? C\'était ici un temple où l\'on m\'a offert la purgation quand j\'étais enfant. J\'ais été également marié ici et j\'ai vu mon fils unique se marier ici aussi.%SPEECH_OFF%Curieux, vous demandez ce qui a détruit le temple. L\'homme rit à nouveau.%SPEECH_ON%Les gens sont venus ici poser les mêmes questions que moi. Des questions divines dans un monde où la terre s\'est manifestée divinisée et a fait renaître les morts. La violence était la réponse qu\'ils ont trouvée - et ils ont donc décidé de la démanteler pierre par pierre. Je les admonesterais pour ça, mais ce serait une ruse. Je ferais probablement la même chose qu\'eux si j\'en avais les moyens, mais, vous savez, je suis vieux, je ne peux pas faire grand-chose à part lever mes propres doigts. C\'est assez facile d\'être le pacifiste quand même une mouche peut vous lécher le nez sans punition.%SPEECH_OFF%Son rire chaleureux revient. Il vous offre un bol en argent.%SPEECH_ON%J\'ai trouvé ceci dans mes recherche. Les moines y mettaient de l\'eau pour purifier les malades. Ce n\'est pas la réponse que je cherchais, mais tenez, prenez-le. Je n\'ai aucune utilité pour de telles choses. Pas maintenant. En aucun cas. Bonne chance là-bas et si vous, vous savez, me revoyez comme \'ça\', s\'il vous plaît, sortez-moi de ma misère.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bonne chance, étranger.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/silver_bowl_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_29.png[/img]Ce sont des temps dangereux, même pour les hommes solides, ce n\'est certainement pas sûr pour un vieux con qui a probablement perdu quelques billes. Tu t\'approches et tu l\'appelles. Instantanément, il secoue la tête, les yeux écarquillés, les pupilles gonflées pour faire de sa vue un abîme sans étoiles. Il pointe un doigt vers vous.%SPEECH_ON%Votre sang. Donnez-le-moi.%SPEECH_OFF%L\'inconnu se lève lentement. Son manteau tombe de son corps, révélant un squelette nu avec seulement le placage de chair le plus fin. Il fonce vers vous. Sa bouche est ouverte, mais il n\'y a pas d\'articulations. Il semble parler entièrement d\'un autre monde.%SPEECH_ON%Mon calcul, ton cramoisi, mon calcul, ton cramoisi.%SPEECH_OFF%%randombrother% saute en avant, arme à la main.%SPEECH_ON%C\'est un sorcier !%SPEECH_OFF Les hommes s\'arment alors que le nécromancien se penche en arrière, sa cape se soulevant du sol et l\'habillant comme si le vent lui-même était à son entière disposition. Soudain, des corps sortent de terre en grognant et en miaulant. Il vous regarde de dessous le bord du chapeau qui s\'abaisse lentement sur ses yeux.%SPEECH_ON%Ainsi soit-il.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.UndeadTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Zombies, this.Math.rand(80, 120), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						properties.Entities.push({
							ID = this.Const.EntityType.Necromancer,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/necromancer",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID(),
							Callback = null
						});
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
			Text = "[img]gfx/ui/events/event_76.png[/img]Soudain, une arbalète pointe par-dessus votre épaule et tire si près que vous pouvez sentir l\'air se précipiter au-delà du bruit de sa corde. L\'éclair transperce le crâne du vieil homme et il penche en avant, la tête dans la boue, les fesses en l\'air, les mains toujours à côté de lui dans une supination découragée.\n\nVous vous retournez pour voir %witchhunter% le chasseur de sorcières debout derrière vous. Il abaisse l\'arbalète et se dirige vers le cadavre, le saisit par la nuque et lui enfonce un pieu dans le dos. Le corps hurle et les vêtements gonflent alors que le corps implose, une poussière tourbillonnante sortant précipitamment de la cape comme si elle avait été surprise en train de se faire passer pour un homme.\n\n Le chasseur de sorcières se tourne vers vous.%SPEECH_ON%Necrosavant. Peu fréquent. Extrêmement dangereux.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uh huh.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/misc/vampire_dust_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
				_event.m.Witchhunter.improveMood(1.0, "A tué un Nécrosavant sur la route");

				if (_event.m.Witchhunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Witchhunter.getMoodState()],
						text = _event.m.Witchhunter.getName() + this.Const.MoodStateEvent[_event.m.Witchhunter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Witchhunter = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
	}

});

