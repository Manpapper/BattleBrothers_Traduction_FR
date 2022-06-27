this.goblin_city_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.goblin_city_enter";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{%randombrother% secoue la tête.%SPEECH_ON%Que les dieux anciens aient pitié de nous pour avoir permis un tel spectacle.%SPEECH_OFF%La cité gobelin est emprisonnée entre des montagnes. Dire que les gobelins ont construit leur cité autour des montagnes, c\'est comme dire qu\'un soldat a rengainé son épée dans la poitrine de son ennemi. Les peaux vertes ne se sont pas simplement installées, elles ont profané l\'endroit, en plaçant des mines là où il y avait des arbres, en construisant un dédale de cabanes rouillées et d\'appentis, en élevant des totems cultuels, en creusant des fosses sacrificielles primitives, en empilant du bois inutilisé, comme si la mutilation de la montagne n\'était pas vraiment complète sans un gaspillage flagrant.\n\n Mais au-delà des déchets gobelins se dresse le noyau central de la ville, un certain nombre de tours qui se distinguent sans ambiguïté de la racaille. Il s\'agit clairement d\'anciennes structures, le travail de la pierre ne ressemble à rien de ce que vous avez déjà vu et dépasse sûrement le potentiel de construction des peaux vertes. Les gobelins qui se promènent entre les murs sont bien droits et fiers, comme s\'ils étaient revigorés d\'être autorisés à fouler ces terres sacrées. L\'intérieur de la forteresse semble appartenir à une sorte de haute noblesse, des gobelins bien habillés avec des serviteurs qui s\'affairent, ce qui signifie la même chose que lorsqu\'il s\'agit d\'humains: Il y a un bon butin à prendre.\n\n On voit de temps en temps des petits qui courent partout. La famille, si c\'est ce que les peaux vertes ont vraiment, signifie qu\'un combat ici serait cruel. Les petits asticots auront plus à protéger que leur sauvagerie et leur avidité, et ce qui doit s\'étendre au-delà de leurs propres vices sera affaibli.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quel est le plan?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Partons pour l\'instant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityVisited", true);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Après avoir observé la ville pendant un certain temps, vous savez que vous ne pouvez pas simplement l\'attaquer de front. Ils sont trop nombreux pour que vous puissiez vous en occuper, et vu le nombre de personnes déjà de leur côté, il est même probable que les familles des gobelins participeront à votre hécatombe, et vous n\'aurez fait que consacrer la ville entière avec une expérience supplémentaire dans le massacre d\'humains. Alors vous attendez. Et vous réfléchissez. Et puis un homme s\'approche.\n\n Il est vêtu d\'une armure légère avec un heaume feuillu servant à camoufler le métal qui se trouve en dessous, une multitude d\'épées cliquètent sur sa hanche, une lance est accrochée sur son dos d\'un côté et une hache de l\'autre, une bandoulière de potions carillonne lorsqu\'il s\'arrête. Vous ne voyez pas son visage, encore moins ses yeux, il dégouline de sang d\'une action toute récente.%SPEECH_ON%Malgré leurs cruautés et leur apparence cruelle, les gobelins sont en quelque sorte un groupe civilisé. Ils répondront à une violence qui n\'est à la base rien d\'autre qu\'une sauvagerie insensée. Si vous souhaitez les attirer, alors vous devez faire comme les orcs. Mon plan était d\'en massacrer autant que je pouvais en trouver dans les champs, des groupes de raid, des éclaireurs, etc, mais c\'est tout aussi bien que leurs campements soient détruits en grand nombre. Ensemble, leur peur sera prise en tenaille, car ils craignent plus que tout les orcs téméraires et chercheront à les éliminer de manière préventive.%SPEECH_OFF%L\'homme acquiesce comme si vous étiez déjà d\'accord sur quelque chose.%SPEECH_ON%Choisissez donc, voyageur, la manière dont vous souhaitez que cette ville soit mise à genoux. Massacrer leurs raids et leurs éclaireurs, ou brûler leurs postes avancés ? Quoi que vous fassiez, je ferai l\'autre, seul, et nous nous retrouverons ici quand le bilan de nos actions sera flagrant.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous allons massacrer leurs éclaireurs et leurs raids.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Nous nous occupons des postes avancés.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Vous lui dites que la compagnie %companyname% va massacrer les gobelins dans les champs. L\'homme acquiesce.%SPEECH_ON%Ah, voyageur, c\'est un bon choix. Les disparitions de ces groupes vont mettre à mal les \"croyances\" des peaux vertes. Ils sont des éclaireurs et des pillards naturels, alors quand ceux de leur espèce disparaissent, ils sont profondément troublés. Les postes avancés vont se retirer et répandre des rumeurs dans la ville et une expédition sera mise en place. Pendant que vous les prenez dans les champs, je veillerai à ce que beaucoup de postes soient détruits. D\'après ma propre expérience, il faut en détruire environ %goblinkillcount% gobelins et ce sera suffisant.%SPEECH_OFF%Il s\'en va, mais vous l\'interpellez en lui demandant qui il est, ou si peut-être ce serait une meilleure idée de se regrouper. Il vous ignore complètement et s\'en va.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous rentrerons après que %goblinkillcount% gobelins aient été tués.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityScouts", true);
				this.World.Flags.set("GoblinCityCount", 0);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Vous dites à l\'étranger que la compagnie %companyname% va poursuivre la destruction des postes avancés. Il acquiesce.%SPEECH_ON%Excellent, voyageur, excellent! Les gobelins envoient fréquemment des groupes de raids et quand ils rentrent chez eux en cendres, ils en envoient d\'autres, les obligeant à sortir des postes avancés. Très bien. Nous avons un plan et d\'après ma propre expérience, vous n\'avez qu\'à prendre aux alentours de %goblinpostcount% postes avancés. Vous prenez leurs postes, je prendrai leurs groupes.%SPEECH_OFF%Il s\'en va, mais vous l\'interpellez en lui demandant qui il est, ou si peut-être ce serait une meilleure idée de se regrouper. Il vous ignore complètement et s\'en va.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous reviendrons après que cinq avant-postes aient été rasés.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityOutposts", true);
				this.World.Flags.set("GoblinCityCount", 0);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Vous retournez dans la ville, mais l\'étranger que vous avez rencontré plus tôt est introuvable. Par contre, ce que vous voyez, c\'est un énorme contingent de forces gobelines qui s\'apprêtent à sortir. Ils sont au pas de course et jacassent bruyamment.Leurs chefs sont assis sur des loups sellés, leurs bannières de guerre s\'inclinant d\'un côté à l\'autre comme s\'il s\'agissait d\'une flotte en mer. Des familles de gobelins sont perchées aux portes. Ils jettent des poignées d\'os sur les marcheurs, et parfois vous voyez un chien ou un membre humain être jeté en contrebas, le gobelin qui l\'attrape le brandit comme un trophée et la cohorte environnante applaudit. Il faut une heure entière pour que l\'armée passe, et au même moment, les gobelins aux portes se retirent dans la ville et quelques gardes s\'affairent.\n\nIl y en a encore beaucoup à combattre, mais pas assez pour faire face à la compagnie %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Préparez l\'attaque.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().m.IsShowingDefenders = true;
						}

						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				},
				{
					Text = "Repliez-vous pour l\'instant.",
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
			ID = "F",
			Text = "[img]gfx/ui/events/event_119.png[/img]{La cité gobelin reste gardée par une horde de petites peaux vertes. Vous vous souvenez que la compagnie %companyname% devra détruire quelques patrouilles et éclaireurs supplémentaires pour éloigner l\'armée de la ville.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous reviendrons après que %goblinkillcount% patrouilles gobelins aient été détruites.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_119.png[/img]{La cité gobelin reste gardée par une horde de petites peaux vertes. Vous vous souvenez que la compagnie %companyname% devra détruire quelques autres de ses campements et postes avancés pour éloigner l\'armée de la ville.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous reviendrons après que %gobelinpostcount% avant-postes gobelins aient été détruits.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
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
		_vars.push([
			"goblinkillcount",
			"ten"
		]);
		_vars.push([
			"goblinpostcount",
			"five"
		]);
	}

	function onDetermineStartScreen()
	{
		if (!this.World.Flags.get("IsGoblinCityVisited"))
		{
			return "A";
		}
		else if (this.World.Flags.get("IsGoblinCityOutposts") && this.World.Flags.get("GoblinCityCount") >= 5 || this.World.Flags.get("IsGoblinCityScouts") && this.World.Flags.get("GoblinCityCount") >= 10)
		{
			return "E";
		}
		else if (this.World.Flags.get("IsGoblinCityScouts"))
		{
			return "F";
		}
		else if (this.World.Flags.get("IsGoblinCityOutposts"))
		{
			return "G";
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
	}

});

