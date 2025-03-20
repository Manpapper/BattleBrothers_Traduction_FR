this.hedgeknight_vs_hedgeknight_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null,
		HedgeKnight2 = null,
		NonHedgeKnight = null,
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.hedgeknight_vs_hedgeknight";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonhedgeknight% bondit dans votre tente, arrachant presque l\'un des piquets et faisant tout tomber. La sueur coule sur son visage et sur vos cartes. Vous regardez l\'homme avec un air qui exige une explication. Il explique que le chevalier errant %hedgeknight1% et %hedgeknight2% sont à deux doigts d\'en venir aux mains. Ils ont tous deux pris des armes et semblent prêts à s\'entretuer. Le fait que ces deux-là se battent n\'est probablement pas le mieux pour la santé de... eh bien, de tout le monde. Vous vous précipitez rapidement sur la scène.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dites-moi où ils sont..",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.NonHedgeKnight.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_35.png[/img]Vous trouvez %hedgeknight1% avec une grande épée à la main et %hedgeknight2% qui fait tourner une hache géante comme un enfant le ferait avec un bâton. La plupart des hommes sont partis. %nonhedgeknight% explique que les deux {ont des comptes à régler après un tournoi de joutes | se sont affrontés auparavant sur un champ de bataille, dans des camps opposés, et cherchent maintenant à poursuivre cet affrontement | cherchent à mettre fin à un conflit entre eux par la vieille tradition du combat à mort}. Un autre frère s\'avance, suppliant les chevaliers errants de mettre leurs différences de côté, mais %hedgeknight2% le pousse hors du chemin. Golems de puissance et de terreur qu\'ils sont, peut-être est-il sage de chercher à mettre fin à cette confrontation?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que le meilleur gagne.",
					function getResult( _event )
					{
						return _event.m.Monk == null ? "C1" : "C2";
					}

				},
				{
					Text = "Écoutez-moi, économisez vos forces pour le champ de bataille!",
					function getResult( _event )
					{
						return _event.m.Monk == null ? "C3" : "C4";
					}

				},
				{
					Text = "Mille couronnes à vous deux pour arrêter cette folie maintenant!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C1",
			Text = "[img]gfx/ui/events/event_35.png[/img]%nonhedgeknight% hurle, vous demandant d\'arrêter le combat. Les deux chevaliers errants se retournent, chaque respiration soulevant leurs poitrines. Vous tendez une main dédaigneuse. Les chevaliers acquiescent et se chargent l\'un l\'autre. Le choc est fort, le métal se fracasse, les os craquent. Les coups portés par les armes sont si bruyants que des grognements accompagnent chaque attaque. L\'épée se prend dans le manche de la hache géante et les deux lames s\'entrechoquent. Les chevaliers errants échangent des regards cruels, puis se désarment rapidement et sortent leurs dagues, ils se poignardent à plusieurs reprises avant de tomber au sol. Aucun des deux hommes ne semble atteints par les blessures. Ils abandonnent leurs misérables dagues et se servent de leurs propres poings, se donnant des coups si violents qu\'on voit des dents voler en éclats au milieu des gouttes de sang.\n\nEncore une fois, la compagnie compte sur votre autorité, car il devient évident que ces hommes cherchent à se battre jusqu\'à la mort.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça devient incontrôlable. Arrêtez-les!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Voyons qui est le plus fort au combat.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " souffre de blessures légères"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "C3",
			Text = "[img]gfx/ui/events/event_35.png[/img]Les deux chevaliers errants se tiennent là, les yeux rivés sur leur adversaire, sans tenir compte de vos paroles, chaque souffle soulevant leur poitrine. Un court instant puis ils se chargent l\'un l\'autre. Le choc est fort, le métal se fracasse, les os se brisent. Les coups portés par les armes sont si bruyants que des grognements accompagnent chaque attaque. L\'épée se prend dans le manche de la hache géante et les deux lames s\'entrechoquent. Les chevaliers errants échangent des regards cruels, puis se désarment rapidement et dégainent leurs dagues, se poignardant à plusieurs reprises avant de tomber au sol. Aucun des deux hommes ne semble atteints par les blessures. Ils abandonnent leurs misérables dagues et se servent de leurs propres poings, se donnant des coups si violents qu\'on voit des dents voler en éclats au milieu des gouttes de sang.\n\nEncore une fois, la compagnie compte sur votre autorité, car il devient évident que ces hommes cherchent à se battre jusqu\'à la mort.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça devient incontrôlable. Arrêtez-les!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Voyons qui est le plus fort au combat.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " souffre de blessures légères"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_35.png[/img]%nonhedgeknight% hurle en vous demandant d\'arrêter le combat. Les deux chevaliers errants regardent, chaque souffle soulevant leurs poitrines. Vous tendez une main dédaigneuse. Les chevaliers acquiescent et se chargent l\'un l\'autre. Le choc est fort, le métal se fracasse, les os craquent. Les coups portés par les armes sont si bruyants que des grognements accompagnent chaque attaque. L\'épée se prend dans le manche de la hache géante et les deux lames s\'entrechoquent. Les chevaliers errants échangent des regards cruels, puis se désarment rapidement et dégainent leurs dagues, se poignardant à plusieurs reprises avant de tomber au sol. Aucun des deux hommes ne semble atteints par les blessures. Ils abandonnent leurs misérables dagues et se servent de leurs propres poings, se donnant des coups si violents qu\'on voit des dents voler en éclats au milieu des gouttes de sang.\n\nEncore une fois, la compagnie compte sur votre autorité, car il devient évident que ces hommes cherchent à se battre jusqu\'à la mort.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça devient incontrôlable. Arrêtez-les!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Voyons qui est le plus fort au combat.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				},
				{
					Text = "%monk% le moine! Pouvez-vous trouver une solution pacifique?",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " souffre de blessures légères"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "C4",
			Text = "[img]gfx/ui/events/event_35.png[/img]Les deux chevaliers errants se tiennent là, les yeux rivés sur leur adversaire, sans tenir compte de vos paroles, chaque souffle soulevant leur poitrine. Un court instant puis ils se chargent l\'un l\'autre. Le choc est fort, le métal se fracasse, les os se brisent. Les coups portés par les armes sont si bruyants que des grognements accompagnent chaque attaque. L\'épée se prend dans le manche de la hache géante et les deux lames s\'entrechoquent. Les chevaliers errants échangent des regards cruels, puis se désarment rapidement et dégainent leurs dagues, se poignardant à plusieurs reprises avant de tomber au sol. Aucun des deux hommes ne semble atteints par les blessures. Ils abandonnent leurs misérables dagues et se servent de leurs propres poings, se donnant des coups si violents qu\'on voit des dents voler en éclats au milieu des gouttes de sang.\n\nEncore une fois, la compagnie compte sur votre autorité, car il devient évident que ces hommes cherchent à se battre jusqu\'à la mort.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça devient incontrôlable. Arrêtez-les!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Voyons qui est le plus fort au combat.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				},
				{
					Text = "%monk% le moine! Pouvez-vous trouver une solution pacifique?",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " souffre de blessures légères"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img]Vous sortez une sacoche remplie de pièces. Les deux chevaliers errants l\'a regardent, le son de l\'or s\'entrechoquant étant difficile à ignorer. %SPEECH_ON%Mille couronnes à chacun d\'entre vous, c\'est d\'accord?%SPEECH_OFF%Les hommes échangent un regard. Ils haussent les épaules. Vous acquiescez.%SPEECH_ON%D\'accord, mais ça ne se reproduira pas, compris?%SPEECH_OFF%Les hommes acquiescent également, s\'approchent et acceptent les couronnes avec une aisance insolente. Certains frères semblent un peu fâchés que ces hommes aient reçu de l\'argent gratuitement pour avoir simplement choisi de ne pas se battre. Étant plus préoccupés à compter l\'argent qu\'à s\'entretuer, les chevaliers errants trouvent, à contrecœur, une certaine paix. Vous espérez juste qu\'ils ont eu le même montant, sinon les \\'festivités\\' vont reprendre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il vaudrait mieux que ça dure.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				this.World.Assets.addMoney(-2000);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]2000[/color] Couronnes"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.HedgeKnight1.getID() || bro.getID() == _event.m.HedgeKnight2.getID())
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.greedy"))
					{
						bro.worsenMood(2.0, "Angry about you bribing men to stop their fight");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(1.0, "Concerned about you bribing men to stop their fight");
					}

					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_35.png[/img]Vous en avez vu assez et ordonnez aux hommes d\'intervenir. Ils hésitent, mais vous leur rappelez rapidement leurs devoirs contractuels. Les hommes s\'emparent de grandes bâches en cuir, de couvertures, de quelques casseroles, de poêles et de seaux. Leur stratégie est solide: Des seaux sont lancés sur la tête des chevaliers errants, les aveuglant juste assez longtemps pour jeter tout le reste sur eux. Les hommes se battent avec les chevaliers errants comme un homme lutterait contre un taureau. Ils sont parfois projetés en l\'air. Un frère reçoit un coup de pied au visage, ce qui lui vaut d\'être édenté. Un autre est englouti sous les couvertures, écrasé entre les chevaliers errants qui grognent comme une boule de colère informe.\n\nLes deux hommes finissent par se calmer et mettent fin à la bataille. Ils font la paix à contrecœur, de peur que vous ne demandiez au reste de vos hommes de prendre de vraies armes pour mettre fin à la rixe. Le reste de la compagnie se remet, ils se relèvent comme si une grande tornade venait de traverser le camp. Vous prenez en compte les blessures et commencez à appliquer les premiers secours",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Enfin, c\'est fini.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.HedgeKnight1.getID() || bro.getID() == _event.m.HedgeKnight2.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 60)
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 75)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " souffre de blessures légères"
						});
					}
					else
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " souffre de " + injury.getNameOnly()
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_35.png[/img]Vous vous installez sur une souche et regardez le reste du combat. Les hommes se roulent par terre, se frappant au visage avec des coups de poing qui tueraient un cheval. Finalement, %hedgeknight1% s\'accroupit sur les épaules de %hedgeknight2%. Voyant un rocher à proximité, %hedgeknight1% le saisit et l\'éclate sur le crâne de son adversaire. Un bout de chair est arraché, dévoilant un mélange de rouge et de blanc en dessous. Le rocher est à nouveau abattu. Un pan du cerveau éclate, les os se brisent en miettes. %hedgeknight2% devient un peu mou, sa motivation semble s\'être envolée. %hedgeknight1% frappe son homonyme en pleine boite crânienne et le laisse se vider de son sang. Vous avez des nausées à la vue de ce spectacle, quelques hommes se retournent et vomissent.\n\n%hedgeknight1% se lève et jette son trophée dans les hautes herbes. Il s\'essuie le front et ne dit qu\'un seul mot.%SPEECH_ON%Terminé.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une mort au combat pour %hedgeknight2%, au final.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				local dead = _event.m.HedgeKnight2;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Killed in a duel by " + _event.m.HedgeKnight1.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight2.getName() + " has died"
				});
				_event.m.HedgeKnight2.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight2.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight2);
				local injury = _event.m.HedgeKnight1.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.HedgeKnight1.getName() + " souffre de " + injury.getNameOnly()
				});

				if (this.Math.rand(1, 2) == 1)
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight1.getBaseProperties().MeleeSkill += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.HedgeKnight1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Maîtrise de Mêlée"
					});
				}
				else
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight1.getBaseProperties().MeleeDefense += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.HedgeKnight1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Maîtrise à Distance"
					});
				}

				_event.m.HedgeKnight1.getSkills().update();
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_35.png[/img]Vous cherchez à vous installer sur une souche proche, mais vous faites un bond en arrière lorsque les deux chevaliers errants foncent sur vous. La tête de %hedgeknight1%% se fracasse en premier sur ce qui devait être votre siège. Il se retourne rapidement pour faire face à son assaillant. Tout ce qu\'il rencontre est la botte de %hedgeknight2%, le contact de la chair et du cuir émettant un bruit répugnant. En se gargarisant, %hedgeknight1% demande à %hedgeknight2% si c\'est tout ce qu\'il a en réserve. En réponse, %hedgeknight2% lui donne des coups de pied à la tête, encore et encore, et chaque fois que sa botte se relève, %hedgeknight1% est dans un état encore pire, passant du rouge sang à une déformation de sa chair et de ses paupières, à un nez aplati et à un sourire horrible où ses dents sont soit manquantes, soit suspendues à des gencives gorgées de sang comme s\'il s\'agissait d\'ongles sur un doigt sans peau.\n\nPour finir, le cerveau est écrasé, ne restant plus que des bribes de cervelle et d\'os. Vous tournez votre regard avec horreur, mais certains frères ne peuvent pas, l\'un d\'eux vomit. En jetant un coup d\'œil pour voir les dégâts, vous voyez que le talon de %hedgeknight2% est posé sur la gorge d\'un homme et que le bout de sa botte lui retourne le cerveau. Il pousse des jurons en essayant de récupérer l\'objet qui a porté le coup fatal.\n\nLe chevalier errant survivant doit tirer sur sa cuisse pour sortir son pied de la cervelle. Se retournant, il traîne son pied dans l\'herbe pour le nettoyer comme un enfant rentrant après une journée de jeu, regardant attentivement pour s\'assurer qu\'il n\'y a pas autre chose à laver. Il enlève un morceau de matière cérébrale et le jette sur le côté comme s\'il venait d\'éplucher du maïs. Se frottant le ventre, il demande si quelqu\'un a faim avant de prendre une assiette de gruau et de retourner à sa propre tente.\n\nPlus tard dans la nuit, et après avoir mis au point un complot éphémère visant à éliminer l\'homme pour la sécurité de la compagnie, vous trouvez %hedgeknight2% endormi comme un bébé.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une mort au combat pour %hedgeknight2%, au final.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				local dead = _event.m.HedgeKnight1;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Killed in a duel by " + _event.m.HedgeKnight2.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight1.getName() + " has died"
				});
				_event.m.HedgeKnight1.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight1.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight1);
				local injury = _event.m.HedgeKnight2.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.HedgeKnight2.getName() + " souffre de " + injury.getNameOnly()
				});

				if (this.Math.rand(1, 2) == 1)
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight2.getBaseProperties().MeleeSkill += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.HedgeKnight2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Maîtrise de Mêlée"
					});
				}
				else
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight2.getBaseProperties().MeleeDefense += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.HedgeKnight2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Maîtrise à Distance"
					});
				}

				_event.m.HedgeKnight2.getSkills().update();
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]Le moine acquiesce, s\'avance et marche calmement entre les deux hommes. Ses mains sont levées, les doigts vont et viennent en imitant les formes des anciens rites religieux. Il parle des dieux et de la façon dont ils jugent les hommes pour ce qu\'ils sont et ce qu\'ils font. Il dit que certains dieux pourraient trouver cette bataille favorable, mais que la plupart ne le feraient pas. Mais surtout, le moine dit que s\'ils souhaitent vraiment se battre, il y a encore beaucoup à faire après leur mort. Cependant, s\'ils s\'entretuent, le perdant bénéficie d\'un grand prestige dans l\'au-delà, ce qui n\'est pas le cas du gagnant, car cette violence ne sert à rien d\'autre qu\'à donner de la fierté au vainqueur. Étonnamment, cette bizarrerie dans les règles religieuses calme les hommes. Le moine les invite à parler davantage, ce qu\'ils font, et tous trois s\'en vont, les mains gesticulant, le dos se voûtant dans un éclat de rire. Quant au reste de la compagnie, ils semblent juste heureux que personne n\'ait été tué.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Remercions les dieux.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());

				if (!_event.m.Monk.getFlags().has("resolve_via_hedgeknight"))
				{
					_event.m.Monk.getFlags().add("resolve_via_hedgeknight");
					_event.m.Monk.getBaseProperties().Bravery += 2;
					_event.m.Monk.getSkills().update();
					this.List = [
						{
							id = 16,
							icon = "ui/icons/bravery.png",
							text = _event.m.Monk.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Détermination"
						}
					];
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 2000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				candidates.push(bro);
			}
			else
			{
				candidates_other.push(bro);

				if (bro.getBackground().getID() == "background.monk")
				{
					candidates_monk.push(bro);
				}
			}
		}

		if (candidates.len() < 2 || candidates_other.len() == 0 && candidates.len() <= 2)
		{
			return;
		}

		local r = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight1 = candidates[r];
		candidates.remove(r);
		r = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight2 = candidates[r];
		candidates.remove(r);

		if (candidates_other.len() > 0)
		{
			this.m.NonHedgeKnight = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		}
		else
		{
			this.m.NonHedgeKnight = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		this.m.Score = (2 + candidates.len()) * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight1",
			this.m.HedgeKnight1.getName()
		]);
		_vars.push([
			"hedgeknight2",
			this.m.HedgeKnight2.getName()
		]);
		_vars.push([
			"nonhedgeknight",
			this.m.NonHedgeKnight.getName()
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
		this.m.HedgeKnight2 = null;
		this.m.NonHedgeKnight = null;
		this.m.Monk = null;
	}

});

