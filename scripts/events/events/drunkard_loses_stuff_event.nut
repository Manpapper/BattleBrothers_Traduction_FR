this.drunkard_loses_stuff_event <- this.inherit("scripts/events/event", {
	m = {
		Drunkard = null,
		OtherGuy = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.drunkard_loses_stuff";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]En faisant l\'inventaire hier soir, %drunkard% a un peu trop bu et a fini par perdre %item% !\n\nOn vous l\'a amené et l\'homme, qui se balance sur ses pieds, pue encore l\'alcool. Il hoquette en essayant de s\'expliquer, mais le mieux qu\'il puisse faire est de s\'effondrer sur le sol dans un état d\'ivresse. L\'homme rit et rit encore, mais vous ne voyez rien de drôle dans tout cela. %otherguy% vous demande ce que vous voulez faire de lui.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tout le monde fait des erreurs.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "La corvée des latrines pendant un mois !",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "S\'il n\'arrête pas de boire, je vais le forcer à le faire. Prennez le fouet.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "D" : "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Item.getIcon(),
					text = "Vous perdez " + this.Const.Strings.getArticle(_event.m.Item.getName()) + _event.m.Item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]L\'ivrogne tombe sur le dos, fixant le ciel sans but. Vous voyez des larmes dans ses yeux et il se couvre le visage, essayant de cacher sa honte. Il y a quelque chose sur lui et son passé que vous ne connaissez pas, peut-être quelque chose qui l\'a conduit à boire en premier lieu. Vous ne pouvez pas punir un homme pour ce qu\'il ne peut pas contrôler.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Emmenez-le hors de ma vue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous prenez une pelle, un seau, et un bout de laine enroulée autour d\'un bâton.%SPEECH_ON%Aux latrines. Pendant un mois.%SPEECH_OFF%L\'ivrogne vous regarde et, les yeux écarquillés, il vous supplie.%SPEECH_ON%Sir, s\'il vous plaît. Je -hic- ne... Les hommes, monsieur, ils -hic-...%SPEECH_OFF%Vous levez la main, pour l\'arrêter. L\'homme vacille en essayant de se tenir droit. En faisant craquer vos articulations, vous lui expliquez l\'autre option.%SPEECH_ON%Si vous ne souhaitez pas avoir ces tâches, alors nous pouvons passer par une punition par le fouet. Que préfères-tu ?%SPEECH_OFF%Étonnamment, l\'ivrogne prend quelques instants pour y réfléchir, les sourcils s\'élevant et s\'abaissant et une grimace passant d\'un côté à l\'autre de sa bouche avec un flot de réalisations qu\'il n\'y a aucun moyen de s\'en sortir. Finalement, il se soumet à la pire des deux options. Plutôt choqué de voir que le choix a pris du temps, vous commencez à vous demander à quel point le régime alimentaire de la compagnie est devenu mauvais.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Emmenez-le hors de ma vue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_38.png[/img]L\'homme a été poussé à boire, alors vous allez le faire désaouler. Vous ordonnez une flagellation. Quelques frères d\'armes traînent l\'ivrogne au loin. Il hoquette et gémit, sa tête rebondit dans tous les sens alors qu\'il ne semble pas se rendre compte de ce qui se passe. Ils l\'attachent sous un arbre et lui déchirent les vêtements qu\'il porte. Après quelques coups de fouet, l\'ivrogne se réveille et se met à crier de manière incontrôlée. Il implore la pitié dans une langue brouillée par la boisson et la douleur, comme un homme qui se bat pour se libérer d\'un cauchemar. Une chose est sûre : il ne fera plus jamais cette erreur.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça lui apprendra.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				_event.m.Drunkard.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Drunkard.getName() + " reçoit une blessure"
					}
				];
				_event.m.Drunkard.getSkills().removeByID("trait.drunkard");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_29.png",
					text = _event.m.Drunkard.getName() + " n\'est plus un ivrogne"
				});
				_event.m.Drunkard.worsenMood(2.5, "A été fouetté sur vos ordres");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Drunkard.getMoodState()],
					text = _event.m.Drunkard.getName() + this.Const.MoodStateEvent[_event.m.Drunkard.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Drunkard.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(1.0, "Consterné par votre ordre d\'avoir fait fouetté " + _event.m.Drunkard.getName());

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

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_38.png[/img]L\'homme a été poussé à boire, alors vous allez le faire désaouler. Vous ordonnez une flagellation. Quelques hommes traînent l\'ivrogne au loin. Il hoquette et gémit, sa tête rebondit dans tous les sens alors qu\'il ne semble pas se rendre compte de ce qui se passe. Ils l\'attachent sous un arbre et déchirent les vêtements de son dos. Après quelques coups de fouet, l\'ivrogne se réveille et se met à crier de manière incontrôlée. Il implore la pitié dans une langue brouillée par la boisson et la douleur, comme un homme qui se bat pour se libérer d\'un cauchemar.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça lui apprendra.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				_event.m.Drunkard.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Drunkard.getName() + " reçoit une blessure"
					}
				];
				_event.m.Drunkard.worsenMood(2.5, "A été fouetté sur vos ordres");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Drunkard.getMoodState()],
					text = _event.m.Drunkard.getName() + this.Const.MoodStateEvent[_event.m.Drunkard.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Drunkard.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7 || bro.getBackground().getID() == "background.flagellant")
					{
						continue;
					}

					bro.worsenMood(1.0, "Consterné par votre ordre d\'avoir fait fouetté " + _event.m.Drunkard.getName());

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

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.drunkard"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local items = this.World.Assets.getStash().getItems();
		local hasItem = false;

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Legendary))
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
			{
				hasItem = true;
				break;
			}
		}

		if (!hasItem)
		{
			return;
		}

		this.m.Drunkard = candidates[this.Math.rand(0, candidates.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Drunkard.getID())
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
		local items = this.World.Assets.getStash().getItems();
		local candidates = [];

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Legendary) || item.isIndestructible())
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
			{
				candidates.push(item);
			}
		}

		this.m.Item = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.World.Assets.getStash().remove(this.m.Item);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"drunkard",
			this.m.Drunkard.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"item",
			this.Const.Strings.getArticle(this.m.Item.getName()) + this.m.Item.getName()
		]);
	}

	function onClear()
	{
		this.m.Drunkard = null;
		this.m.OtherGuy = null;
		this.m.Item = null;
	}

});

