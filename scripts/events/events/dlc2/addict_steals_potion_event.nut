this.addict_steals_potion_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.addict_steals_potion";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous allez vérifier le stock pour trouver %addict% plongé à moitié dans un tonneau, les quatre membres dépassant du rebord. Il a ingurgité bon nombre de fioles. Il vous regarde fixement avec des yeux sombres et rougis, et les orbites qui les contiennent sont violettes comme si tout le sang s\'y était précipité. Vous demandez ce qui se passe et %addict% ne fait que de sourire.%SPEECH_ON%Faites, euh, faites ce que vous devez faire. Er, capitaine. Car j\'ai déjà gagné.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère juste que tu guériras à temps.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Il faut que ça cesse maintenant, %addict%.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 33 ? "C" : "D";
					}

				},
				{
					Text = "Assez. Je vais faire sortir ce démon sanguinaire de toi!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Item.getIcon(),
					text = "Vous perdez " + this.Const.Strings.getArticle(_event.m.Item.getName()) + _event.m.Item.getName()
				});
				local items = this.World.Assets.getStash().getItems();

				foreach( i, item in items )
				{
					if (item == null)
					{
						continue;
					}

					if (item.getID() == _event.m.Item.getID())
					{
						items[i] = null;
						break;
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]{Vous avez amené %addict% jusqu\'au pilori pour le faire fouetter. Il s\'allonge mollement contre le bois, ses doigts s\'écartent, se coincent et se serrent. Il a l\'air de chasser des papillons, et il garde ce regard absent lorsque %otherbrother% le fouette violemment.\n\n Le fouet ne fait rien, pas même lorsqu\'il claque sur le dos de l\'homme, laissant des croissants pourpres. Mais après quelques coups, il se met à prendre conscience et commence à crier. Vous vous retournez pour lui faire face et lui demander s\'il veut bien renoncer à sa dépendance. Il hoche précipitamment la tête. Vous le laissez se faire fouetter à nouveau, et vous lui demandez à nouveau, et à nouveau il acquiesce. Un autre coup de fouet, une autre question, une autre réponse. Et ainsi de suite, jusqu\'à ce que son corps soit en sang et que ce qui le faisait souffrir ai complètement disparu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mettez-le hors de ma vue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				_event.m.Addict.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Addict.getName() + " est blessé"
					}
				];
				_event.m.Addict.getSkills().removeByID("trait.addict");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_29.png",
					text = _event.m.Addict.getName() + " n\'est plus dépendant"
				});
				_event.m.Addict.worsenMood(2.5, "Was flogged on your orders");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Addict.getMoodState()],
					text = _event.m.Addict.getName() + this.Const.MoodStateEvent[_event.m.Addict.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(1.0, "Appalled by your order to have " + _event.m.Addict.getName() + " flogged");

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous sortez %addict% du tonneau et le jetez au sol. Il vacille comme si le sol était un escalier et sa dernière marche, un précipice.%SPEECH_ON%Hé, monsieur, attention, c\'est très profond!%SPEECH_OFF%Vous pensez d\'abord à lui botter le cul, mais n\'en faites rien. Vous vous accroupissez et vous vous posez à côté de l\'homme qui se retourne pour fixer les nuages. Le temps passe, et au bout d\'un moment, %addict% se pince les lèvres et on peut voir que la lucidité est revenue dans ses yeux.%SPEECH_ON%J\'ai un problème, monsieur.%SPEECH_OFF%Vous acquiescez et lui dites d\'y aller doucement avec les potions, que vous ne pouvez pas lui faire confiance dans cet état. Si il rencontre une difficulté avec le fait d\'être un mercenaire, si c\'est la raison pour laquelle il est comme ça, alors c\'est bon, mais c\'est un problème. Il se pince à nouveau les lèvres et acquiesce.%SPEECH_ON%Merci, monsieur. Je vais faire de mon mieux pour me libérer de cette emprise et remettre les choses en ordre.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien dit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				_event.m.Addict.getSkills().removeByID("trait.addict");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_62.png",
					text = _event.m.Addict.getName() + " n\'est plus dépendant"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous sortez %addict% du tonneau et le jetez au sol. Il vacille comme si le sol était un escalier et sa dernière marche, un précipice.%SPEECH_ON%Hé, monsieur, attention, c\'est très profond!%SPEECH_OFF%Vous pensez d\'abord à lui botter le cul, mais n\'en faites rien. Vous vous accroupissez et vous vous posez à côté de l\'homme qui se retourne pour fixer les nuages. Après un moment, il vous jete un coup d\'oeil.%SPEECH_ON%Vous essayez de m\'aider?%SPEECH_OFF%Vous acquiescez, mais %addict% sourit simplement et secoue la tête.%SPEECH_ON%C\'est pas à toi que je parle, c\'est à toi que je parle!%SPEECH_OFF%Il pointe le baril derrière vous, et le temps que vous vous retourniez, l\'homme est debout et vous charge.%SPEECH_ON%Le gros connard veut faire le malin avec moi, hein!%SPEECH_OFF%Le mercenaire s\'attaque au tonneau qui se fend de haut en bas et un certain nombre d\'objets en sortent et se brisent. Quelques mercenaires se précipitent sur l\'homme et l\'emmènent pendant que vous comptez ce qui a été détruit.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon sang.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local items = this.World.Assets.getStash().getItems();
				local candidates = [];

				foreach( i, item in items )
				{
					if (item == null || item.isItemType(this.Const.Items.ItemType.Legendary) || item.isItemType(this.Const.Items.ItemType.Named))
					{
						continue;
					}

					if (item.isItemType(this.Const.Items.ItemType.Misc))
					{
						candidates.push(i);
					}
				}

				if (candidates.len() != 0)
				{
					local i = candidates[this.Math.rand(0, candidates.len() - 1)];
					this.List.push({
						id = 10,
						icon = "ui/items/" + items[i].getIcon(),
						text = "Vous perdez " + items[i].getName()
					});
					items[i] = null;
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		local items = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.getID() == "misc.potion_of_knowledge" || item.getID() == "misc.antidote" || item.getID() == "misc.snake_oil" || item.getID() == "accessory.recovery_potion" || item.getID() == "accessory.iron_will_potion" || item.getID() == "accessory.berserker_mushrooms" || item.getID() == "accessory.cat_potion" || item.getID() == "accessory.lionheart_potion" || item.getID() == "accessory.night_vision_elixir")
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Item = candidates_items[this.Math.rand(0, candidates_items.len() - 1)];
		this.m.Score = candidates_addict.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"item",
			this.Const.Strings.getArticle(this.m.Item.getName()) + this.m.Item.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
		this.m.Item = null;
	}

});

