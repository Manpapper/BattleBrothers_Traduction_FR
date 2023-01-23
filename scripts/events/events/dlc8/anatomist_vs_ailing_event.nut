this.anatomist_vs_ailing_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Ailing = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_ailing";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%ailing%, le mercenaire souffrant, est recroquevillée et regarde fixement le feu de camp. Il est malade depuis un certain temps et ne semble pas aller mieux. Cependant, %anatomist% l\'anatomiste suggère qu\'il pourrait être en mesure de concocter une solution pour l\'homme, une sorte de potion qu\'il pourrait absorber pour renforcer son corps et se guérir.%SPEECH_ON%Je l\'ai vu fonctionner de nombreuses fois. Maintenant, il y a un problème: les ingrédients requis ne sont pas originaires de notre région, mais j\'ai lu suffisamment sur le sujet pour trouver facilement des substituts appropriés.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Va et guéris-le de ses maux.",
					function getResult( _event )
					{
						local outcome = this.Math.rand(1, 100);

						if (outcome <= 33)
						{
							return "B";
						}
						else if (outcome <= 66)
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
					Text = "Non, ça ne semble pas sûr du tout.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous laissez %anatomist% faire son travail, quel qu\'il soit. L\'anatomiste et %ailing% disparaissent dans une tente pendant un moment. Quand la compagnie est prête à reprendre la route, %ailing% est un homme neuf. Il est revivifié par des énergies nouvelles, et il a un certain ressort dans sa démarche. %anatomiste% sort en prenant des notes dans son livre.%SPEECH_ON%Les résultats ont été très bons, très bons même.%SPEECH_OFF%Curieux, vous lui demandez ce qu\'il a fait. Il vous fixe, puis il repousse le livre pour que vous ne puissiez pas le lire. Il continue à murmurer dans sa barbe.%SPEECH_ON%De bons résultats? Non, je ne peux pas écrire \"bons résultats\". Il pourrait encore souffrir d\'effets qui pourraient se manifester de manière un peu, comment dire, latérale.%SPEECH_OFF%Eh bien, avec un peu de chance, %ailing% est simplement guéri et c\'est tout.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route alors.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_59.png",
						text = _event.m.Ailing.getName() + " is no longer Ailing"
					}
				];
				local healthBoost = this.Math.rand(2, 4);
				_event.m.Ailing.getBaseProperties().Hitpoints += healthBoost;
				_event.m.Ailing.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Ailing.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + healthBoost + "[/color] Hitpoints"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous donnez le feu vert à %anatomist%. Lui et %ailing% s\'éloignent un moment et entrent ensemble dans une tente. Les heures passent et la compagnie devrait bientôt reprendre la route. Vous vous approchez et entrez dans la tente. %ailing% est sur un lit de camp, les bras croisés au-dessus de sa tête et les jambes pliées aux genoux. Il est couvert de sueur et tourne sans cesse la tête de gauche à droite. %anatomiste% est à ses côtés et prend des notes.%SPEECH_ON%Il semble que la procédure n\'ait pas fonctionné comme prévu, mais même les conséquences involontaires peuvent être porteuses d\'informations de grande importance.%SPEECH_OFF%Furieux, vous demandez si l\'homme va s\'en sortir. L\'anatomiste acquiesce.%SPEECH_ON%Il peut souffrir d\'illusions pendant un certain temps, mais en fin de compte, il sera toujours un animal qui respire - excusez-moi, un homme qui respire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route alors.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_59.png",
					text = _event.m.Ailing.getName() + " is no longer Ailing"
				});

				if (!_event.m.Ailing.getSkills().hasSkill("trait.paranoid"))
				{
					local trait = this.new("scripts/skills/traits/paranoid_trait");
					_event.m.Ailing.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Ailing.getName() + " gains Paranoid"
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous décidez de laisser l\'anatomiste faire ce qu\'il doit faire, en espérant que %ailing% se rétablira rapidement. Le temps file et vous devez remettre la compagnie en ordre de marche. Or, %anatomist% n\'est toujours pas sorti de la tente. Vous allez y jeter un coup d\'œil.\n\nVous trouvez l\'anatomiste assis sur un tabouret à l\'écart. Il a un bras en écharpe sur une table, sa main prend des notes. Son autre bras est détendu entre ses jambes, son pouce et son doigt se pressent de temps à autre dans un étrange mouvement de pincement qui semble compter les secondes. Vous portez votre regard sur %ailing% qui est assis sur un lit de camp, les jambes sur les côtés et les pieds sur le sol. Il lève les yeux vers vous.%SPEECH_ON%Hé là, capitaine, je pense que je me sens beaucoup mieux maintenant. Beaucoup, beaucoup mieux. Prêt à... conquérir le monde.%SPEECH_OFF%L\'homme se lève d\'un bond et se frappe la poitrine, mais sa voix ne porte pas.%SPEECH_ON%On reprend la route?%SPEECH_OFF%Il sort de la tente et à la seconde où la bâche se referme, %anatomiste% cesse d\'écrire et pose sa plume d\'oie. Il hoche la tête.%SPEECH_ON%La procédure a été un succès. Il n\'est plus malade. Il est guéri et plus encore.%SPEECH_OFF%Plus encore? Ce n\'est pas le genre de langage que vous voulez voir en ce moment. Vous devrez garder un œil sur l\'homme pour voir ce qui a changé chez lui.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fini les expériences, monsieur l\'anatomiste.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_59.png",
					text = _event.m.Ailing.getName() + " is no longer Ailing"
				});
				local new_traits = [
					"scripts/skills/traits/bloodthirsty_trait",
					"scripts/skills/traits/brute_trait",
					"scripts/skills/traits/cocky_trait",
					"scripts/skills/traits/deathwish_trait",
					"scripts/skills/traits/dumb_trait",
					"scripts/skills/traits/gluttonous_trait",
					"scripts/skills/traits/impatient_trait",
					"scripts/skills/traits/irrational_trait",
					"scripts/skills/traits/paranoid_trait",
					"scripts/skills/traits/spartan_trait",
					"scripts/skills/traits/superstitious_trait"
				];
				local num_new_traits = 2;

				while (num_new_traits > 0 && new_traits.len() > 0)
				{
					local trait = this.new(new_traits.remove(this.Math.rand(0, new_traits.len() - 1)));

					if (!_event.m.Ailing.getSkills().hasSkill(trait.getID()))
					{
						_event.m.Ailing.getSkills().add(trait);
						this.List.push({
							id = 10,
							icon = trait.getIcon(),
							text = _event.m.Ailing.getName() + " gains " + trait.getName()
						});
						num_new_traits = num_new_traits - 1;
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous dites à %anatomiste que non. %ailing% est assez fort pour guérir tout seul. L\'anatomiste soupire. Vous avez l\'impression qu\'il n\'avait pas vraiment envie d\'aider le mercenaire, mais seulement de faire des expériences sur lui.%SPEECH_ON%Les grandes avancées ne peuvent être faites qu\'avec de grands risques, capitaine.%SPEECH_OFF%Il dit ça avant de partir, sa plume d\'oie griffonnant un nom sur l\'un de ses tomes.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et à propos de l\'avancée de mon poing dans ta...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local ailingCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.ailing"))
			{
				ailingCandidates.push(bro);
			}
		}

		if (ailingCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Ailing = ailingCandidates[this.Math.rand(0, ailingCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * ailingCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"ailing",
			this.m.Ailing.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Ailing = null;
	}

});

