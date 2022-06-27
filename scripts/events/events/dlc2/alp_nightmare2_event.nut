this.alp_nightmare2_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.alp_nightmare2";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
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
						return "E";
					}

				},
				{
					Text = "Il faut que ça cesse maintenant, %addict%.",
					function getResult( _event )
					{
						return "D";
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
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]{Vous avez amené %addict% jusqu\'au pilori pour le faire fouetter. Il s\'allonge mollement contre le bois, ses doigts s\'écartent, se coincent et se serrent. Il a l\'air de chasser des papillons, et il garde ce regard absent lorsque %otherbrother% le fouette violemment.\n\n Le fouet ne fait rien, pas même lorsqu\'il claque sur le dos de l\'homme, laissant des croissants pourpres. Mais après quelques coups, il se met à prendre conscience et commence à crier. Vous vous retournez pour lui faire face et lui demander s\'il veut bien renoncer à sa dépendance. Il hoche précipitamment la tête. Vous le laissez se faire fouetter à nouveau, et vous lui demandez à nouveau, et à nouveau il acquiesce. Un autre coup de fouet, une autre question, une autre réponse. Enfin, %otherbrother% relâche le fouet et l\'enroule.%SPEECH_ON%Il est mort, monsieur.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quoi? Laissez-moi voir!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Addict.getName() + " est mort"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID() || bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Vous vous précipitez en avant et allez soulever la tête de l\'homme, mais ce n\'est qu\'une cruche attachée à une lance. En reculant, vous vous heurtez à %addict% qui est en train de trier l\'inventaire.%SPEECH_ON%Capitaine, vous allez bien ?%SPEECH_OFF%En hochant la tête, vous lui demandez comment se portent les stocks de potions. Il sourit.%SPEECH_ON%Tout est comptabilisé. Dois-je recompter?%SPEECH_OFF%Vous lui dites de compter autre chose et vous vous dirigez vers votre tente pour boire un verre. En se retournant, une silhouette pâle s\'éloigne d\'une des caisses. Vous dégainez votre épée et le pourchassez, mais vous ne trouvez qu\'un drap flottant au vent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peut-être que j\'ai juste besoin de repos.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Vous sortez %addict% du tonneau et le jetez au sol. Il se retourne rapidement et crie avec une clarté parfaite.%SPEECH_ON%C\'est quoi ce bordel, capitaine?%SPEECH_OFF%Ce n\'est pas du tout %addict%, mais %otherbrother%. En détournant le regard, vous voyez %addict% en train d\'affuter une lame. Une silhouette pâle se déplace au loin, mais quand vous clignez des yeux, elle a disparu. Vous remettez l\'autre frère sur pied et lui dites de faire attention aux voleurs. Il acquiesce consciencieusement, peut-être sentant que quelque chose ne va pas avec vous, ou peut-être ne voulant pas vous affronter pour une erreur. Vous retournez à votre tente pour boire un verre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peut-être que je devrais plutôt dormir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous laissez l\'homme tranquille, mais à la seconde où vous vous retournez, vous entendez le fracas du verre et le gargarisme de l\'homme qui l\'a détruit. En vous retournant, vous trouvez %addict% avec des lambeaux de chair en guise de cou, il retire du verre de sa gorge exposée. Vous vous précipitez à son secours, posant votre main contre la plaie et vous pouvez sentir sa gorge se plisser contre vos doigts comme la bouche d\'un poisson échoué. L\'homme s\'effondre au sol, de tout son poids, de son poids sans vie, de son poids mort.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'aurais dû prendre des mesures...",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Addict.getName() + " est mort"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 66)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Vous inclinez votre tête vers le sol, ressentant une telle honte que vous vous rappelez les jours où vous vous préoccupiez des anciens dieux. Lorsque vous relevez la tête, vous vous retrouvez les doigts dans un sac de grain dont le contenu se répand partout.%SPEECH_ON%Oy capitaine, on doit utiliser ça.%SPEECH_OFF%En regardant par-dessus, vous voyez %addict% et une ombre blanche derrière lui. Vous vous précipitez mais dans ce tumulte, l\'ombre est partie. Vous ne la trouvez pas, aucune empreinte et, ne souhaitant pas effrayer davantage %addict%, vous dites au mercenaire de garder un œil attentif aux alentours. Vous allez dans votre tente pour boire un verre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peut-être un verre ou deux, voir trois.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
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
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else
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
		this.m.Score = 10;
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

