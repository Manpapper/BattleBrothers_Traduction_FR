this.read_black_book_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.read_black_book";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{%nonhistorian% entre dans votre tente.%SPEECH_ON%Capitaine, venez vite, il y a un problème avec %historien%!%SPEECH_OFF%Vous vous précipitez sur les lieux. L'%historien% est penché sur le livre du Gardien du savoir comme un homme ancien protégeant la première flamme. Il serre les couvertures en chair, les mains tremblantes, et il vous regarde avec des yeux injectés de sang.%SPEECH_ON% Je sais ce qu'il dit, capitaine, je sais ce qu'il dit!%SPEECH_OFF% Vous vous accroupissez et l'homme recule en secouant la tête.%SPEECH_ON%Non. Non ! Il s'agit de la fin ! La fin de toutes choses ! Nous sommes... nous sommes simplement des outils pour y arriver, tu ne comprends pas ? Tout ce que nous faisons, tout ce que quiconque fait, est un moyen d'atteindre la fin ultime : la mort de tous les êtres. Notre existence même lui donne du pouvoir, sans nous, elle peut se reposer. Mais tant qu'il existe, il ne peut pas dormir !%SPEECH_OFF% Vous secouez la tête et demandez ce qu'il veut dire. L'homme tourne le livre et il y a une page entièrement noire, mais il pointe son doigt vers un endroit comme si vous deviez y lire une phrase.%SPEECH_ON% Ce n'est pas un livre, capitaine, c'est une instruction, sur la façon de réveiller les esprits des morts.%SPEECH_OFF% Vous demandez qui pourrait avoir une telle connaissance, et %historien% sourit follement.%SPEECH_ON% Il n'y a pas de qui, il n'y a pas de quoi! C'est un outil de destruction, mis dans ce monde par celui qui se fait appeler Davkul!%SPEECH_OFF% Vous dites aux hommes de l'abriter car il a clairement perdu la tête. Un des mercenaires t'apporte les traductions du livre de %historien%, mais ce ne sont que des gribouillages, pas moins inintelligibles que leur source.%SPEECH_ON%Même si on pouvait en comprendre un mot, même si on pouvait l'utiliser, je ne pense pas qu'on devrait. Tu vois, et juste entre nous, mais cette page qu'il t'a montrée ? Il y avait du texte dessus tout à l'heure. Et je veux dire qu'au moment même où vous vous approchiez. Je pouvais voir les mots, je pouvais voir les symboles. Mais à un moment, l'encre, la cendre, quoi que ce soit, s'est répandue sur toute la page. C'est comme si nous n'étions pas censés avoir cette connaissance. C'est tout à fait possible, mais il y a une réalisation plus sombre qui se répand dans votre esprit : l'%historien% est censé avoir cette connaissance, mais sa compréhension limitée n'est pas pour votre bénéfice, mais simplement un outil dans les machinations de quelque chose d'entièrement différent. On vous montre seulement ce dont vous avez besoin et pas plus...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C'est une pensée inquiétante.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/traits/mad_trait");
				_event.m.Historian.getSkills().add(effect);
				_event.m.Historian.improveMood(2.0, "A vu la fin des choses");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Historian.getName() + " est devenu fou"
				});
				this.Characters.push(_event.m.Other.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]{%nonhistorian% entre dans votre tente.%SPEECH_ON%Capitaine, venez vite, il est arrivé quelque chose à %historien%!%SPEECH_OFF%Vous vous précipitez sur les lieux. L'%historien% est penché sur le livre du Gardien du savoir comme un homme ancien protégeant la première flamme. Il serre les couvertures en chair, les mains tremblantes, et il vous regarde avec des yeux injectés de sang.%SPEECH_ON% Je sais ce qu'il dit, capitaine, je sais ce qu'il dit!%SPEECH_OFF% Vous vous accroupissez et l'homme recule en secouant la tête.%SPEECH_ON%Non. Non ! Il s'agit de la fin ! La fin de toutes choses ! Nous sommes... nous sommes simplement des outils pour y arriver, tu ne comprends pas ? Tout ce que nous faisons, tout ce que quiconque fait, est un moyen d'atteindre la fin ultime : la mort de tous les êtres. Notre existence même lui donne du pouvoir, sans nous, elle peut se reposer. Mais tant qu'il existe, il ne peut pas dormir !%SPEECH_OFF% Vous secouez la tête et demandez ce qu'il veut dire. L'homme tourne le livre et il y a une page entièrement noire, mais il pointe son doigt vers un endroit comme si vous deviez y lire une phrase.%SPEECH_ON% Ce n'est pas un livre, capitaine, c'est une instruction, sur la façon de réveiller les esprits des morts.%SPEECH_OFF% Vous demandez qui pourrait avoir une telle connaissance, et %historien% sourit follement.%SPEECH_ON% Il n'y a pas de qui, il n'y a pas de quoi ! C'est un outil de destruction, mis au monde par Davkul !%SPEECH_OFF%Un des hommes vous apporte les traductions du livre faites par %historien%, mais ce ne sont que des gribouillages, tout aussi inintelligibles que leur source.%SPEECH_ON%Et entre nous, mais cette page qu'il vous a montrée ? Il y avait du texte dessus plus tôt. Et je veux dire qu'au moment même où vous vous approchiez. Je pouvais voir les mots, je pouvais voir les symboles. Mais à un moment, l'encre, la cendre, quoi que ce soit, s'est répandue sur toute la page. C'est comme si nous n'étions pas censés avoir cette connaissance. C'est tout à fait possible, mais il y a une réalisation plus sombre qui se répand dans votre esprit : l'%historien% est censé avoir cette connaissance, mais sa compréhension limitée n'est pas pour votre bénéfice, mais simplement un outil dans les machinations de quelque chose d'entièrement différent. On vous montre seulement ce dont vous avez besoin et pas plus...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul nous attend tous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/traits/mad_trait");
				_event.m.Historian.getSkills().add(effect);
				_event.m.Historian.improveMood(2.0, "A vu la fin des choses");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Historian.getName() + " est devenu fou"
				});
				this.Characters.push(_event.m.Other.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.Flags.get("IsLorekeeperDefeated") || this.World.Flags.get("IsLorekeeperTradeMade"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_historian = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.mad"))
			{
				return;
			}

			if (bro.getBackground().getID() == "background.historian" && bro.getLevel() >= 2 || bro.getBackground().getID() == "background.cultist" && bro.getLevel() >= 9)
			{
				candidates_historian.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_historian.len() == 0 || candidates_other.len() == 0)
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

		this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian.getName()
		]);
		_vars.push([
			"nonhistorian",
			this.m.Other.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
		{
			return "B";
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
		this.m.Historian = null;
		this.m.Other = null;
	}

});

