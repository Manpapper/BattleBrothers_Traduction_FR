this.sunken_library_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.sunken_library_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_173.png[/img]{L\'éclat et la brillance sont tels que vous avez presque l\'impression que le doreur lui-même vous a rendu visite. Malheureusement ou heureusement, ce sur quoi vous êtes tombé est en fait un grand dôme doré qui dépasse très légèrement des sables. Immédiatement, vous essayez d\'arracher un peu d\'or, mais il ne cède pas. Le %randombrother% vous appelle vers une dalle de pierre qui a une ouverture. Peut-être un clocher à un moment donné ? La lumière s\'estompe rapidement et vous ne pouvez pas voir grand chose à l\'intérieur. Au-dessus de l\'entrée, un relief représente des hommes tirant des chariots de parchemins. Il y a un ensemble de mots griffonnés à plusieurs reprises sur le relief. Aucune de ces langues ne ressemble de près ou de loin à ce que tu as déjà vu ou entendu. Il te faut un peu de temps pour trouver une traduction gravée à la hâte par quelqu\'un de ton époque : La bibliothèque, le labyrinthe de la nuit, le labyrinthe de l\'esprit, sortez d\'ici comme vous sortiriez d\'un rêve, marchez ici comme vous marcheriez dans un rêve, sortez pour vous attarder sur l\'horreur de ne pas savoir, entrez pour ne faire qu\'un avec le savoir, et en connaissant le rêve, connaissez le cauchemar.%SPEECH_OFF% %randombrother% vous le dit, et l\'expression de son visage suggère qu\'il espère que vous refuserez la proposition.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Descendre en rappel dans l\'obscurité!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ne dérangeons pas ce qui repose ici..",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

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
			Text = "[img]gfx/ui/events/event_89.png[/img]{La descente est périlleuse, l\'obscurité est si épaisse que vous ne pouvez même pas voir vos propres bottes. Mais vous finissez par atteindre un sol marbré et allumez rapidement quelques torches. Vous vous retrouvez dans un hall massif autour duquel s\'enroulent des rangées et des rangées de bibliothèques. Chaque étagère est ornée de piles de parchemins, dont beaucoup sont enfermés dans des vitrines. Les étagères sont empilées les unes sur les autres et semblent monter jusqu\'au plafond d\'où vous êtes descendu. Des échelles roulantes se trouvent à chaque niveau, mais plus haut encore, il y a une mezzanine flottante avec des glissières métalliques disposées ici et là. Il semble qu\'il fut un temps où l\'on devait faire passer ces parchemins de haut en bas, bien que maintenant tout soit rouillé et que la mezzanine se soit effondrée par endroits. Il vous montre un énorme parchemin aplati derrière une vitre. Des dessins s\'étalent sur le papier, et en y regardant de plus près, il apparaît qu\'il s\'agit de plans pour apparemment tout : le corps humain, le corps de nombreux animaux, des châteaux, des tours, des moulins à vent, des bateaux, des armes et des armures, des bottes et des gants, des alignements d\'étoiles, et un grand nombre de dessins de choses que vous n\'avez jamais vues auparavant, des choses qui n\'ont pas de sens.%SPEECH_ON%Capitaine, cet endroit n\'est pas fait pour nous. Les langues, les salles, nous devrions partir.%SPEECH_OFF%Un des compagnons souligne la tension palpable dans l\'air. Vous avez absolument pénétré dans un endroit où peu sont allés auparavant. Et s\'ils y sont allés avant, où sont-ils ? Un endroit comme celui-ci ne peut pas rester caché, n\'est-ce pas ?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quel était ce bruit ??",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_89.png[/img]{%SPEECH_START%Des intrus dans la bibliothèque. La voix gratte le sol marbré et s\'élève jusqu\'à vos oreilles et continue, le mot bibliothèque se glissant dans l\'obscurité derrière vous. Soudain, un certain nombre de vitrines se mettent à briller, les phylactères renfermant une sorte d\'énergie éthérée, et lorsque la lumière s\'élargit, elle dévoile le torse d\'un squelette noir, le corps capturé dans l\'air. La cage thoracique contient un livre, accroché par les plis maladifs de ses propres côtes comme une araignée s\'accrocherait à son repas. Le crâne de la créature vous regarde avec des orbites sans pareilles. %SPEECH_ON%Votre espèce m\'a déjà volé, maintenant vous osez profaner ces salles encore une fois?%SPEECH_OFF%Les phylactères deviennent plus brillants et à son tour le torse du squelette devient chair, les mauvaises herbes des veines et la pulpe de la peau s\'épanouissent pour couvrir l\'os. Mais c\'est seulement le torse qui est encastré. Vous fixez les phylactères et ils débordent d\'énergie maintenant, et en les fixant, vous pouvez voir les visages fantômes s\'étaler sur le verre comme des filets de pluie. Vous entendez un grand claquement et vous vous retournez pour voir Le Gardien des Lieux au complet, ses yeux enflammés de feu blanc, ses membres maigres mais avec des muscles fumants qui s\'enroulent autour de sa structure, et sa moitié inférieure se couvre de cendres noires alors qu\'il glisse vers l\'avant. Plus les ampoules de verre sont brillantes, plus il devient fort et rapide !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Battez-vous pour vos vies ! Combattez comme vous ne l\'avez jamais fait auparavant !",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "SunkenLibrary";
						p.TerrainTemplate = "tactical.sinkhole";
						p.LocationTemplate.Template[0] = "tactical.sunken_library";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.IsWithoutAmbience = true;
						p.Entities = [];

						for( local i = 0; i < 4; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.SkeletonHeavyBodyguard);
						}

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}

						p.BeforeDeploymentCallback = function ()
						{
							local phylacteries = 10;
							local phylactery_tiles = [];

							do
							{
								local x = this.Math.rand(10, 28);
								local y = this.Math.rand(4, 28);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local skip = false;

									foreach( t in phylactery_tiles )
									{
										if (t.getDistanceTo(tile) <= 5)
										{
											skip = true;
											break;
										}
									}

									if (skip)
									{
									}
									else
									{
										local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/phylactery", tile.Coords);
										e.setFaction(f);
										phylacteries = --phylacteries;
										phylactery_tiles.push(tile);
									}
								}
							}
							while (phylacteries > 0);

							local toRise = 5;

							do
							{
								local r = this.Math.rand(0, phylactery_tiles.len() - 1);
								local p = phylactery_tiles[r];

								if (p.SquareCoords.X > 14)
								{
									p.Level = 3;
									toRise = --toRise;
								}

								phylactery_tiles.remove(r);
							}
							while (toRise > 0 && phylactery_tiles.len() > 0);

							local lich = 1;

							do
							{
								local x = this.Math.rand(9, 10);
								local y = this.Math.rand(15, 17);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_lich", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									lich = --lich;
								}
							}
							while (lich > 0);

							local treasureHunters = 3;

							do
							{
								local x = this.Math.rand(9, 11);
								local y = this.Math.rand(11, 21);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie_treasure_hunter", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									treasureHunters = --treasureHunters;
								}
							}
							while (treasureHunters > 0);

							local heavy = 4;

							do
							{
								local x = this.Math.rand(9, 14);
								local y = this.Math.rand(8, 20);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_heavy", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									heavy = --heavy;
								}
							}
							while (heavy > 0);

							local heavy_polearm = 4;

							do
							{
								local x = this.Math.rand(12, 14);
								local y = this.Math.rand(12, 26);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_heavy_polearm", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									heavy_polearm = --heavy_polearm;
								}
							}
							while (heavy_polearm > 0);
						};
						p.AfterDeploymentCallback = function ()
						{
							this.Tactical.getWeather().setAmbientLightingPreset(5);
							this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_89.png[/img]{Le Gardien des Lieux s\'effondre sur le sol en un tas de cendres et les phylactères s\'effacent lentement pour redevenir sombres. Vous vous approchez, une torche à la main. Son crâne noir repose sur le livre qui se trouvait autrefois dans sa poitrine.%SPEECH_ON%Capitaine, je ne pense pas que nous devrions toucher quoi que ce soit ici.%SPEECH_OFF%Vous ignorez un de vos hommes et prenez le livre. Sa couverture en cuir est cousue ensemble, et en regardant de plus près, vous pouvez voir la chair des oreilles et des nez entourant la couverture. Immédiatement, les os des morts-vivants tués griffent le sol marbré. L\'un d\'eux passe entre vos jambes et s\'envole dans le tas de cendres. Un feu blanc terne s\'allume dans la cavité du crâne. C\'est plus que suffisant pour vous : d\'un ordre rapide, vous faites remonter les hommes sur la corde, vous êtes le dernier à partir. Alors que vous vous approchez de la lumière de la terre au-dessus, vous prenez un moment pour regarder vers le bas et - le crâne noir est déjà dans votre visage ! Il flotte seul, les yeux blancs brûlants, capturant votre vue dans un cône de feu que vous ne pouvez pas comprendre, et tandis que vous le fixez, vous pouvez entendre les voix de vos hommes s\'éteindre. Le crâne flotte seul, et vous ressentez presque l\'envie de lâcher la corde. Le crâne parle à votre esprit:%SPEECH_ON%Ce n\'est qu\'un de ses cadeaux, intrus et vous n\'êtes pas le premier à l\'avoir. Il y en a beaucoup qui l\'ont pris, et dans la multitude il n\'y a qu\'une seule fin, celle qui nous attend tous!%SPEECH_OFF%Le feu du crâne s\'éteint et il tombe dans l\'obscurité où vous entendez un bref cliquetis. Les voix de vos hommes reviennent, plus fortes que jamais, et vous levez les yeux pour voir la main de %randombrother%. Ils s\'y accrochent et vous tirent vers l\'extérieur. Lorsque vous sortez, l\'entrée s\'enfonce dans le sable, et tout ce qui vous reste de l\'endroit est un livre étrange, charnu, rempli d\'écritures que vous ne pourrez jamais espérer déchiffrer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce que je viens de prendre?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Après la bataille...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/black_book_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				this.World.Flags.set("IsLorekeeperDefeated", true);
				this.updateAchievement("Lorekeeper", 1, 1);
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_173.png[/img]Les hommes courent et se hâtent de remonter.%SPEECH_ON%Peut-être une autre fois?%SPEECH_OFF%Un soldat dit. %randombrother% hoche la tête. %SPEECH_ON%Une autre fois, oui. Peut-être un temps très lointain, quand je serai à la retraite et que j\'aurai fait le tapin, alors vous pourrez tous plonger dans les ténèbres et vous promener avec des sorciers morts. Ce moment vous convient-il ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peut-être qu\'un jour...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "Après la bataille...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
	}

	function onUpdateScore()
	{
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

