this.gladiators_vibes_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator1 = null,
		Gladiator2 = null
	},
	function create()
	{
		this.m.ID = "event.gladiators_vibes";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_155.png[/img]{%gl1% regarde %gl2% s\'épiler les sourcils, utilisant l\'éclat de la lame de son arme comme miroir. %SPEECH_ON% Votre dos semble épais et tendu, %gl2%. Ca c\'est bon !.%SPEECH_OFF%Le gladiateur se retourne et hoche la tête.%SPEECH_ON%Merci, je l\'utilise pour porter cette compagnie.%SPEECH_OFF% | %SPEECH_ON%Contrôle de forme!%SPEECH_OFF%%gl1% est en plein milieu du squat quand il crie. %gl2% se précipite vers le gladiateur, lui palpe les fesses et lui crie Vas-y !. L\'homme plonge le squat bien au-delà de quatre-vingt-dix degrés. %SPEECH_ON%C\'est serré!%SPEECH_OFF%%gl2% confirme.%SPEECH_ON%C\'est serré comment ? %SPEECH_OFF%%gl2% retire une main, la transforme en poing et frappe le cul de l\'homme. Il agite ensuite sa main d\'avant en arrière comme si elle avait touché une poêle chaude.%SPEECH_ON% Plus serré que la bourse d\'un Vizir!%SPEECH_OFF%%gl1% termine son accroupissement et se relève et ils se frappent la poitrine.%SPEECH_ON%Ton tour, mec ! C\'est parti!%SPEECH_OFF% | %SPEECH_ON%Hey. Regarde ça.%SPEECH_OFF%%gl1% La poitrine de Ève rebondit, un sein à la fois. Tu lui dis beaux seins et tu passes à autre chose, mais il t\'attrape.%SPEECH_ON%Ce ne sont pas des seins, ce sont des pectoraux. Et ils sont magnifiques. Hé. Dis qu\'ils sont beaux. Un sein rebondit, puis l\'autre, d\'avant en arrière. En soupirant, tu dis qu\'ils sont beaux. %gl1% acquiesce et essuie quelque chose de son œil.%SPEECH_ON%Merci, capitaine.%SPEECH_OFF% Tu trouves %gl1% en train de presser %gl2% sur un banc, ce dernier lisant un parchemin en montant et descendant.%SPEECH_ON%On dit que l\'état de la%randomcitystate% a de belles femmes.%SPEECH_OFF%Il se retourne vers l\'homme qui le soulève. Gl1% vous regarde, puis retourne à son entraînement.%SPEECH_ON% Quatre-vingt-dix-neuf. Cent ! Bon, retourne-toi.%SPEECH_OFF%%gl2% se retourne, les mains de %gl1%% se posent sur sa poitrine et son ventre.%SPEECH_ON%Alors, encore cent répétitions.%SPEECH_OFF%%gl1% lève quatre doigts. %gl2% en lève six. En hochant la tête, %gl1% rit. %SPEECH_ON%En une nuit ? %SPEECH_OFF%L\'autre gladiateur acquiesce. %SPEECH_ON%Oui. En une nuit.%SPEECH_OFF%%gl1% rit et demande si ce sont toutes des femmes. %gl2% hésite.%SPEECH_ON%Eh bien, il y avait quelques hommes. Mais on n\'a pas eu l\'occasion de se toucher ou quoi que ce soit. On s\'est quand même rapprochés, parce qu\'à un moment il était là, et j\'étais positionné comme ça derrière-%SPEECH_OFF%Vous vous approchez en applaudissant, pas pour applaudir mais pour dire aux gladiateurs de rester concentrés. Tu comprends que les routes peuvent être longues et ennuyeuses, mais là, ça devient ridicule. | Je pourrais briser le cou d\'une mule avec un seul bras. secouant la tête, %gl2% demande pourquoi il fléchit les deux bras alors. Tu l\'interromps en disant aux gladiateurs qu\'ils ne tueront pas d\'animaux tant qu\'ils n\'auront pas accompli la tâche principale de %companyname% qui consiste à tuer des animaux de temps en temps. | %gl1% s\'assied à côté de %gl2% et se détourne. Il dit : %SPEECH_ON%Mettez votre main sur ma colonne vertébrale. Juste entre les épaules.%SPEECH_OFF%L\'autre gladiateur s\'exécute sans question ni curiosité. A son tour, %gl1% se plie, coinçant la main de l\'homme entre deux masses de muscles.%SPEECH_ON% Comment trouves-tu cette puissance ? %SPEECH_OFF%De nouveau, sans une once d\'ironie ou d\'incrédulité, %gl2% oblige une réponse.%SPEECH_ON% C\'est génial, mec ! Je peux entendre les os de mes mains craquer !%SPEECH_OFF% Vous pensez à l\'interrompre, mais techniquement, personne n\'est blessé... pour l\'instant. Vous laissez les gladiateurs à leurs, eh, proclivités. | Donc je l\'ai eu sur le chariot à fruits comme ça et on s\'amuse comme des fous quand son père arrive. Il reste bouche bée et peut à peine sortir un mot. Il hoche la tête. Alors je lui dis, regarde ça. Et je me recule et je fléchis les deux bras et lentement, très lentement, elle se soulève du sol.%SPEECH_OFF%%gl2% gifle l\'autre gladiateur sur sa poitrine étincelante.%SPEECH_ON% Tu mens ! C\'est un tas de mensonges!%SPEECH_OFF%Le gladiateur lève la main.%SPEECH_ON%Par la lumière du Doreur, et quels que soient les autres dieux qui se penchent sur mon corps, c\'est la vérité. Mon poteau a du pouvoir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tant mieux pour vous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator1.getImagePath());
				this.Characters.push(_event.m.Gladiator2.getImagePath());
				_event.m.Gladiator1.improveMood(1.0, "Se sent fort et beau");

				if (_event.m.Gladiator1.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator1.getMoodState()],
						text = _event.m.Gladiator1.getName() + this.Const.MoodStateEvent[_event.m.Gladiator1.getMoodState()]
					});
				}

				_event.m.Gladiator2.improveMood(1.0, "FSe sent fort et beau");

				if (_event.m.Gladiator2.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator2.getMoodState()],
						text = _event.m.Gladiator2.getName() + this.Const.MoodStateEvent[_event.m.Gladiator2.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_155.png[/img]{%gl1% fait irruption dans votre tente.%SPEECH_ON%Capitaine ! Vite, %gl2% a besoin d\'aide!%SPEECH_OFF%Vous vous précipitez hors de la tente et trouvez %gl2% assis devant le feu de camp. Il tremble presque. %gl1% vous dit que l\'homme a fait un cauchemar.%SPEECH_ON% Il a rêvé qu\'il était un homme si maigre qu\'il pouvait à peine soulever un panier de pommes. Les femmes lui crachaient dessus. Les enfants le fuyaient de peur. Et il allait aux arènes, sauf qu\'il devait s\'asseoir dans les gradins!%SPEECH_OFF%%gl2% lève les yeux au ciel avec tristesse.%SPEECH_ON%Ce n\'était même pas de bonnes places, capitaine. Ce n\'était même pas de bonnes places.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'était juste un mauvais rêve.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator1.getImagePath());
				this.Characters.push(_event.m.Gladiator2.getImagePath());
				_event.m.Gladiator2.worsenMood(1.0, "J\'ai fait un mauvais rêve sur le fait de ne pas être fort et beau.");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Gladiator2.getMoodState()],
					text = _event.m.Gladiator2.getName() + this.Const.MoodStateEvent[_event.m.Gladiator2.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local r = candidates.len() - 1;
		this.m.Gladiator1 = candidates[r];
		candidates.remove(r);
		local r = candidates.len() - 1;
		this.m.Gladiator2 = candidates[r];
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gl1",
			this.m.Gladiator1 != null ? this.m.Gladiator1.getName() : ""
		]);
		_vars.push([
			"gl2",
			this.m.Gladiator2 != null ? this.m.Gladiator2.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.Math.rand(1, 100) <= 90)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.Gladiator1 = null;
		this.m.Gladiator2 = null;
	}

});

