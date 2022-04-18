this.trade_black_book_event <- this.inherit("scripts/events/event", {
	m = {
		Translator = null
	},
	function create()
	{
		this.m.ID = "event.trade_black_book";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Un homme s\'est approché du camp. Vous quittez votre tente pour le trouver debout, les mains sur une lance en or, dont la hampe se ramifie en pointes aiguisées. Aussi menaçante que l\'arme puisse paraître, une paire de cruches à eau et des bibelots en or l\'ont alourdie à d\'autres fins. L\'homme lui-même rejette un manteau pour révéler un visage très particulier et pâle qui n\'a pas un seul poil sur la chair. Il se présente avec une articulation sans faille.%SPEECH_ON%Bonjour étranger, je m\'appelle Yuchi Eveohtse. Je suis à la recherche de deux choses dans ces terres, et j\'ai compris que l\'une d\'entre elles est en votre possession. C\'est un texte profond sur la nature, non, l\'existence de la mort. Je crois que l\'un de vos hommes a déjà percé une partie de ses mystères et, pour l\'instant, il ne vous est plus d\'aucune utilité.%SPEECH_OFF%%traducteur% hoche la tête, affirmant que tant qu\'il fixera les pages, il ne pourra rien en tirer de plus et doute que quiconque le puisse. Yuchi siffle et vous vous retournez vers lui. L\'homme tend trois doigts. %SPEECH_ON%En échange du livre, j\'ai l\'un de ces objets à offrir : soit un bouclier d\'or que les fidèles de ces terres appellent l\'étreinte du doreur, mes deux cruches qui, une fois bues, renforceront un homme au-delà de votre imagination, ou, puisque vous êtes des mercenaires, une somme de 50 000 couronnes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On échange le livre contre le bouclier d\'or.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "On échange le livre contre les deux cruches.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "On échange le livre contre 50 000 couronnes.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Translator.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Un homme s\'est approché du camp. Vous quittez votre tente pour le trouver debout, les mains sur une lance en or, dont la hampe se ramifie en pointes aiguisées. Aussi menaçante que l\'arme puisse paraître, une paire de cruches à eau et des bibelots en or l\'ont alourdie à d\'autres fins. L\'homme lui-même rejette un manteau pour révéler un visage très particulier et pâle qui n\'a pas un seul poil sur la chair. Il se présente avec une articulation sans faille.%SPEECH_ON%Hello étranger, je m\'appelle Yuchi Eveohtse. Je suis à la recherche de deux choses dans ces terres, et j\'ai compris que l\'une d\'entre elles est en votre possession. Il s\'agit d\'un texte profond sur la nature, non, l\'existence de la mort.%SPEECH_OFF%L\'homme tend trois doigts.%SPEECH_ON%En échange du livre, j\'ai l\'une de ces choses à offrir : soit un bouclier d\'or que les fidèles de ces terres appellent l\'étreinte du Doreur, mes deux cruches qui, une fois bues, renforceront un homme au-delà de votre imagination, ou, étant donné que vous êtes des mercenaires, une somme de 50 000 couronnes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On échange le livre contre le bouclier d\'or.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "On échange le livre contre les deux cruches.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "On échange le livre contre 50 000 couronnes.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi s\'incline un bref instant et quand il se lève, il tient un bouclier. Au premier coup d\'œil, il semble n\'être rien de plus que de l\'acier avec des dorures ornées autour des bords, mais soudainement une orbe de lumière jaune tourne autour du bord extérieur, dansant autour et autour. Voyez, si vous deviez tourner cela contre vos ennemis, la lumière deviendrait si aveuglante que vos ennemis ne verraient rien. Et comme vous pouvez le voir, la lumière est maintenant terne, car nous ne sommes pas des ennemis, étranger.%SPEECH_OFF%L\'homme tend la main. Vous lui donnez le livre, et il vous donne le bouclier. Il ne regarde même pas le livre, il le range simplement et ramasse sa lance. Vous lui demandez ce qu\'il compte faire avec le texte. Il sourit. %SPEECH_ON%Qui sait. Peut-être que je vais simplement le rendre, hm ? Ou peut-être pas.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quelle est la deuxième chose pour laquelle vous êtes venu ?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "Vous perdez " + book.getName()
				});
				local item = this.new("scripts/items/shields/legendary/gilders_embrace_shield");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez the " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi pointe sa lance dorée en avant. Elle est incroyablement tranchante, comme quelque chose dont un forgeron pourrait rêver mais qu\'aucun mortel ne pourra jamais réaliser. La paire de cruches glisse et il les attrape par leurs sangles et les tend. Vous lui donnez le livre et il lâche les cruches. Ne voulant pas être empoisonné, vous lui demandez de prendre un verre des deux cruches, ce qu\'il fait volontiers. S\'essuyant la bouche, il hoche la tête.%SPEECH_ON%Je suis assez sensible à ses saveurs et ses effets, s\'il vous plaît ne gaspillez pas plus sur vos suspicions et hésitations.%SPEECH_OFF%L\'homme range le livre quelque part dans sa cape, ramasse son équipement et commence à s\'éloigner. Vous lui demandez ce qu\'il compte faire avec le texte. Il sourit. %SPEECH_ON%Qui sait. Peut-être que je vais simplement le rendre, hm ? Ou peut-être pas.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quelle est la deuxième chose pour laquelle vous êtes venu ?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "Vous perdez " + book.getName()
				});
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/trade_jug_01_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez a " + item.getName()
				});
				item = this.new("scripts/items/special/trade_jug_02_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez a " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi hoche la tête. %SPEECH_ON%Donne moi le livre et apporte moi ton trésor de guerre.%SPEECH_OFF%Tu lui jette le texte et fait amener le trésor de la compagnie devant l\'homme. Il tend les deux bras de ses manteaux et les fait lentement basculer vers l\'avant. Les couronnes s\'échappent des manches apparemment sans fin et puis en un instant l\'homme lève les deux bras.%SPEECH_ON%Votre %récompense% couronnes devrait être là.%SPEECH_OFF%Vous faites compter les pièces et c\'est le montant exact. Tu lèves la tête pour dire qu\'il a de la chance, mais l\'homme est déjà en train de ramasser ses affaires et de se préparer à partir.%SPEECH_ON% Prends soin de toi, étranger.%SPEECH_OFF%Avant qu\'il parte, tu lui demandes ce qu\'il compte faire avec le texte. Il sourit. %SPEECH_ON%Qui sait. Peut-être que je vais simplement le rendre, hm ? Ou peut-être pas.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quelle est la deuxième chose pour laquelle vous êtes venu ?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "Vous perdez " + book.getName()
				});
				this.World.Assets.addMoney(50000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]50,000[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi se retourne. %SPEECH_ON%Hm?%SPEECH_OFF%Vous expliquez qu\'il a dit qu\'il était venu sur ces terres pour chercher deux choses. L\'une était le livre, quelle était l\'autre ? Il sourit. %SPEECH_ON%Il y a une ville dans ces régions qui s\'appelle Dagentear. La ville n\'existe plus, mais quelque chose qui y vivait erre toujours. Un être qu\'on appelle le Wight. Je souhaite le trouver et lui parler.%SPEECH_OFF%Quand vous lui demandez plus d\'informations, il s\'en va simplement en s\'inclinant gracieusement.%SPEECH_ON%Merci pour ta gentillesse, étranger. %SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère que nous avons fait le bon choix en lui donnant ce livre...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsLorekeeperTradeMade", true);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.Flags.get("IsLorekeeperDefeated"))
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasBlackBook = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.black_book")
			{
				hasBlackBook = true;
				break;
			}
		}

		if (!hasBlackBook)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.militia")
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local candidates_mad = [];

			foreach( bro in brothers )
			{
				if (bro.getSkills().hasSkill("trait.mad"))
				{
					candidates_mad.push(bro);
					break;
				}
			}

			if (candidates_mad.len() == 0)
			{
				return;
			}

			this.m.Translator = candidates_mad[this.Math.rand(0, candidates_mad.len() - 1)];
		}

		this.m.Score = 150;
	}

	function onPrepare()
	{
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.militia")
		{
			return "A2";
		}
		else
		{
			return "A";
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"translator",
			this.m.Translator != null ? this.m.Translator.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Translator = null;
	}

});

