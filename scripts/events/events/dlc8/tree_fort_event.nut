this.tree_fort_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.tree_fort";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous tombez sur un groupe d\'enfants assis dans une cabane en haut d\'un arbre. Des yeux brillent à travers les hublots, vous pouvez voir des lance-pierres prêts à l\'emploi. Alors que vous évaluez la situation, ils remontent l\'échelle de corde et vous disent de déguerpir. Curieux, vous vous demandez ce qu\'ils pourraient avoir de valeur pour agir comme ça face à un groupe d\'hommes qui les détruiraient presque certainement. Comme les enfants cèdent facilement à la pression, vous leur demandez s\'ils ne cachent pas quelque chose. L\'un d\'eux fait un mouvement de branlette et vous dit de dégager, tandis qu\'un autre lui tape sur l\'épaule et lui dit de se taire. Pas vraiment les réactions d\'enfants qui cachent des friandises ou des pâtisseries. Ils ont certainement quelque chose de précieux là-haut.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "À l\'assaut!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
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
					Text = "Nous n\'avons pas le temps pour ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
				{
					this.Options.push({
						Text = "Oathtakers!",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous ordonnez à la compagnie %companyname% d\'attaquer la cabane. Incapables de grimper à l\'arbre sous la menace de pierres et de frondes, vous demandez aux hommes de construire des échelles en lançant leurs propres cordes. Les enfants crient et jettent des bâtons et des pierres, infligeant une quantité indescriptible de dommages, mais pas autant que les mots qu\'ils utilisent à gorge déployée, des choses horribles comme \"observateurs d\'oiseaux\" et \"bites de cochons\", les sales petits bâtards. Quelques-uns parviennent à couper les cordes pendant que les hommes grimpent, ce qui entraîne encore plus de blessures. Mais les mercenaires finissent par se débarrasser des enfants, les jetant hors dans le vide avec une grande ferveur. Sans surprise, votre intuition était tout à fait juste: les enfants avaient caché du matériels. Vous prenez la marchandise et faites brûler la cabane et l\'arbre sur lequel elle repose.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Foutus gamins.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local weapons = [
					"weapons/military_pick",
					"weapons/morning_star",
					"weapons/hand_axe",
					"weapons/reinforced_wooden_flail",
					"weapons/scramasax"
				];
				local item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous pointez deux doigts en avant, ordonnant aux hommes d\'attaquer la cabane. Les enfants répondent avec des lance-pierres et des rochers. Prétextant que les pierres ne font pas mal, vous dites aux enfants d\'abandonner. En retour, ils vous traitent \"d\'\idiot incapable\" et de \"sans cervelles\#. Ces mots blessent presque autant que les pierres et les rochers.\n\nSoudain, les habitants de la cabane trouvent des renforts lorsqu\'un groupe d\'autres enfants se joignent à la mêlée depuis les branches de l\'arbre adjacent, les bâtards affluant comme des pirates marins abordant un navire. L\'assaut est en train de partir en vrille et quelques hommes se plaignent que l\'affaire est tout simplement trop pénible pour être poursuivie. Vous vous demandez s\'ils ne sont pas juste inquiets pour leur fierté. En soupirant, vous ordonnez l\'arrêt de cette attaque. Les enfants rient et se moquent de vous%SPEECH_ON%Ils n\'avaient probablement rien là-haut de toute façon. Ça ne vaut pas la peine de s\'embêter.%SPEECH_OFF%C\'est ce que l\'un de vos homme dit . Vous n\'êtes pas d\'accord, mais ça ne sert à rien de s\'y attarder. Les enfants se rassemblent et font des bruits de poulets pendant que vous vous éloignez.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça aurait pu mieux se passer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " suffers " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " suffers light wounds"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_183.png[/img]{Vous prenez le crâne d\'Anselm et le brandissez. D\'une voix forte, vous expliquez les épreuves et les triomphes du jeune Anselme, l\'Oathtaker original. Les enfants sont impressionnés, ils se regardent les uns les autres tandis que vous leur racontez des histoires de courage et d\'honneur. Finalement, les enfants sortent une arme plutôt surprenante.%SPEECH_ON%On l\'a trouvé dans un étang.%SPEECH_OFF%Un autre enfant le pousse.%SPEECH_ON%Non, c\'était dans une pierre! Souviens-toi, c\'est moi qui l\'ai retiré!%SPEECH_OFF%Les enfants se battent entre eux pendant un moment, mais finalement une petite fille prend l\'arme et la lance par la fenêtre de la cabane. La lame s\'enfonce dans le sol, l\'acier grésillant en se pliant d\'avant en arrière. La petite fille se gausse.%SPEECH_ON%C\'est peut-être mieux que quelqu\'un d\'autre prenne ce truc, ils ne font que se battre pour ça!%SPEECH_OFF%Vous enroulez votre main autour de la poignée de l\'épée. Vous la retirez du sol et remerciez les enfants pour leur contribution à la quête des Oathtakers. Les enfants se regardent les uns les autres. L\'un demande à l\'autre.%SPEECH_ON%Avons-nous une sorte de but maintenant?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/noble_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				foundTown = true;
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = this.World.getTime().Days <= 25 ? 10 : 5;
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

