this.lend_men_to_build_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lend_men_to_build";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]En approchant de %townname%, un homme du coin vous fait signe de venir. Il est debout à côté du début de ce qui semble être un moulin. Exaspéré, il explique que ses ouvriers ne sont pas venus aujourd'hui et qu'il doit terminer le moulin avant l'arrivée d'un baron local. S'il ne le termine pas, le baron pourrait ne plus lui donner de contrat. Vous avez quelques anciens ouvriers dans la compagnie. Peut-être peuvent-ils être utilisés pour aider cet homme ?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous construisez, nous tuons. Trouvez quelqu'un d'autre.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Très bien, je peux me passer d'un homme ou deux.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous acceptez de prêter quelques-uns des meilleurs éléments de %companyname% au projet. Ils retombent dans leurs anciens rôles comme un gant, s'affairant rapidement à collecter des ressources, à marteler, à briquer, à ouvrir une porte ? Peu importe ce qu'il faut faire pour installer une porte, ils le font et rapidement. Lorsque tout est terminé, l'homme du coin vient vous voir en souriant jusqu'aux oreilles. Il vous tend une sacoche.%SPEECH_ON% Vous l'avez méritée, mon bon monsieur ! Et plus encore, vous avez mérité ma parole - je répandrai votre bienveillance dès que je le pourrai!%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne vous habituez pas trop à ce genre de travail, messieurs.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Vous avez mis à disposition des hommes pour aider à construire un moulin");
				this.World.Assets.addMoney(150);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color] Couronnes"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " is exhausted"
							});
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "Helped build a mill");

							if (bro.getMoodState() >= this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous acceptez d'aider cet homme. Malheureusement, il semble qu'il n'ait pas bien planifié les choses. Le toit s'effondre à la seconde où l'un de vos\ "ouvriers\" y met le pied, envoyant l'homme dans un gouffre de tuiles. Un autre homme enfonce un clou, mais le support en bois se brise en deux, lui envoyant des éclats de bois au visage. Les briques en vrac se libèrent, la boue humide fait glisser les hommes et toutes sortes de dangers sur le lieu de travail font basculer le projet dans un désastre. L'homme du coin s'excuse abondamment tout en se rongeant les ongles et en se demandant comment il va s'y prendre avec le baron. En claquant des doigts, il s'exclame qu'il va simplement lui payer les couronnes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ces couronnes nous appartiennent !",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Bonne chance avec le baron, alors.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]Alors que l'esprit de l'homme dérive vers une conclusion satisfaisante de son problème, vous claquez des doigts pour le ramener à la cruelle réalité.%SPEECH_ON%Ces couronnes nous appartiennent, paysan. C'était le marché.%SPEECH_OFF% Les mâchoires de l'homme s'agitent en secouant la tête.%SPEECH_ON% Mais le moulin... il n'est même pas fini!%SPEECH_OFF% Vous haussez les épaules.%SPEECH_ON% Pas notre problème. Maintenant donnez l'argent, avant que je ne fasse de toi notre problème.%SPEECH_OFF%Hochant la tête solennellement, l'homme obéit et vous donne sa sacoche de couronnes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Meilleure chance la prochaine fois.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(-this.Const.World.Assets.RelationFavor, "Vous avez poussé un citoyen important à vous payer pour avoir aidé à construire un moulin.");
				this.World.Assets.addMoney(200);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] Couronnes"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " est épuisé"
							});
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "A aidé à construire un moulin");

							if (bro.getMoodState() >= this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]Pendant un bref instant, vous vous voyez en train de transpercer l'homme aux yeux bridés avec votre épée. Ça l'aurait vraiment réveillé à la réalité du monde, mais au lieu de ça, vous lui donnez une pause. Les ouvriers qui ont pris part à ce projet désastreux ne sont pas très heureux. Espérons que les leçons apprises les fortifieront quand même.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon vent.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Vous avez mis à disposition des hommes pour aider à construire un moulin");
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " est épuisé"
							});
						}

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.worsenMood(1.0, "A aidé à construire un moulin sans être payé");

							if (bro.getMoodState() < this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() > 3000)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			local id = bro.getBackground().getID();

			if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

