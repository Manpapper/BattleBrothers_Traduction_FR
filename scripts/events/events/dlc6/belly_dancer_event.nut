this.belly_dancer_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.belly_dancer";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Une danseuse du ventre magnétise la place centrale de %townname%. Les mouvements rythmiques peuvent à eux seuls contraindre un mendiant à donner une couronne, mais avec la scène de la place entière, cela suffit à attirer les foules et avec elles des tas d'or. Masquée par de la soie verte, presque transparente, et vêtue de soies fines dont toute la partie médiane est exposée, la danseuse est sans aucun doute une experte dans son domaine. Elle tourbillonne, les hanches hypnotiques, les coudes pliés, les mains frappant des petites cymbales, les pieds sur la pointe des pieds tandis qu'elle tourne sur un point si serré qu'il se pourrait bien qu'un dieu invisible au-dessus d'elle la maintienne en place tandis qu'elle éblouit et éblouit. Quelqu'un lance une pomme dans les airs et la danseuse tourne sur elle-même et tire une minuscule dague à travers elle, la bouchant en plein centre et faisant tomber le fruit au sol. Une autre pomme s'envole et cette fois, elle sort un grand sabre qui tranche la tige, attrape le reste et en prend une bouchée. La foule applaudit doucement à cela.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "bien fait, ayez une couronne.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Il est temps de partir.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous sortez une couronne et la tendez à la danseuse. Ses yeux en perçoivent l'éclat, mais elle n'interrompt pas la danse. Elle laisse tomber ses armes et s'avance, les cymbales s'entrechoquent, les hanches tournent, ses genoux se plient à peine, ses pieds la portent presque mystiquement sur le sol. Elle s'approche. Le visage est étroit, mais la mâchoire large. Ses tempes sont profondes. Elle sourit. C'est un homme. C'est un homme. Il frappe les cymbales dans votre visage, puis se balance, gratifiant brièvement votre aine de son cul, et commence à danser à nouveau vers le milieu. Il ramasse votre pièce avec un orteil et la retourne pour qu'elle atterrisse dans un pot d'argile. La foule applaudit.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peut-être pouvons-nous utiliser cet homme ?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Il est temps de partir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-1);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]1[/color] Crown"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Après que le danseur du ventre manouche ait pris votre couronne, vous attendez la fin du spectacle. Vous vous approchez alors qu'il ramasse ses affaires. Il vous regarde avec un sourire en coin.%SPEECH_ON%Ah, un admirateur. Désolé, seulement un spectacle ce soir, bon étranger.%SPEECH_OFF%Vous secouez la tête et lui demandez s'il s'y connaît en combat. Il hoche la tête. %SPEECH_ON% Bien sûr que oui. La lueur du Doré est sur nous tous, mais pas à toute heure ou jour. Parfois nous devons trouver notre propre chemin dans l'obscurité. D'après votre tenue, je suppose que vous êtes un Crownling, et que vous mettez votre lame là où il faut et parfois là où il ne faut pas.%SPEECH_OFF% Vous acquiescez et lui demandez s'il serait intéressé à se joindre à vous. Il s'incline et s'écroule sur le sol comme une poutrelle qui s'effondre. Il compte ses couronnes.%SPEECH_ON%Je ne suis pas sûr que vous ayez un bon œil pour la nature vagabonde d'hommes comme moi. Peut-être avez-vous vu une fatigue professionnelle dont je n'étais même pas conscient jusqu'à maintenant. Cela dit, vous devrez faire plus d'efforts pour que je tue pour de l'argent.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu as le talent de la lame comme je ne l'avais jamais vu auparavant.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "E" : "D";
					}

				},
				{
					Text = "Je te paye 500 couronnes tout de suite si tu te joins à nous.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"belly_dancer_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé %name% dans " + _event.m.Town.getName() + ", masqué par de la soie verte et attirant les foules avec des mouvements rythmés et une précision impressionnante dans la découpe des fruits. Cette dernière compétence est une aubaine pour toute compagnie de mercenaires, et vous n'avez donc pas hésité à le recruter.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/dexterous_trait");
				_event.m.Dude.getSkills().add(trait);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Tu rassures son ego en disant qu'il est l'un des meilleurs avec la lame que tu aies vu. Le danseur tourne ses mains vers la poussière, ses doigts glissant sous chaque pièce et la faisant basculer dans son pot d'argile. Sa main gauche se tend sur le sol, mais au moment où elle attire votre attention, sa main droite saisit une lame qui avait été entièrement enfouie sous les sables. Il la tient vers votre entrejambe.%SPEECH_ON%Je suis mortel avec cette lame, comme je suis sûr que vous l'êtes avec ce dard là. Maintenant, je sais que vous ne faites que caresser les choses qui me feront ronronner, en vous attaquant à ma fierté comme le chasseur le fait avec les lions, et je dirai ceci : ça a marché. Je me battrai pour vous, capitaine des Crownlings, et je me battrai bien.%SPEECH_OFF%En hochant la tête, vous lui demandez de baisser la lame. Il la fait tourner dans sa main et la rengaine en un seul mouvement rapide. Il se lève, se déshabille jusqu'à ce qu'il soit nu comme un ver.%SPEECH_ON% Cette vie, je la laisserai derrière moi en entier, et à la vie du Crownlingue je serai dévoué en entier.%SPEECH_OFF%Vous serrez la main de l'homme. Un passant vous regarde et se gratte la tête.%SPEECH_ON%Attendez une minute, vous avez un serpent là-dessous ! Je pensais que vous étiez une dame de la danse, mais ça...%SPEECH_OFF%Il se tamponne le front avec un chiffon et baisse la voix.%SPEECH_ON%C'est encore mieux comme ça.%SPEECH_OFF%Le danseur vous regarde et rit.%SPEECH_ON%We'Nous avons tous des dangers à affronter dans nos vocations respectives, Crownling, et j'ai hâte de voir les vôtres.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans la compagnie !",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous dites au danseur qu'il est l'un des meilleurs que vous ayez vu avec une lame. Il rit. Une tentative vraiment bien intentionnée de votre part, Crownling, de m'entraîner dans votre mode de vie. Mais tu sais bien qu'il n'y a rien que tu puisses dire ou faire qui me ferait quitter cette vie. Oui, la lame me va bien, mais il en va de même pour le fait de flirter avec la foule, de gagner des louanges sans verser de sang pour cela. Va jouer au gladiateur sur le sable et gagne ton argent, Crownling, et je serai ici à gagner le mien.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je devais demander.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous offrez cinq cents couronnes au danseur. Il continue à ramasser des pièces - une par une - et à les mettre dans son pot d'argile. C'est presque une affaire silencieuse, les pièces claquent bruyamment lorsqu'elles tombent dans un tonneau d'argile presque vide. Il lève les yeux, les baisse. Il met une couronne de plus puis se lève. Il se déshabille et tend la main.%SPEECH_ON% Le Doré doit nous regarder tous les deux, pour que tu aies gagné un tel bien, et sans doute a-t-il guidé ta bourse jusqu'ici pour me l'apporter.%SPEECH_OFF% Tu acquiesces et lui serre la main. Un passant vous regarde et se gratte la tête.%SPEECH_ON%Attendez une minute, vous avez un serpent là-dessous ! Je pensais que tu étais une dame de la danse, mais ça...%SPEECH_OFF%Il se tamponne le front et baisse la voix.%SPEECH_ON%C'est encore mieux.%SPEECH_OFF%Soupirant, le danseur lui demande de jeter un coup d'oeil à ton inventaire.%SPEECH_ON%Avec un corps comme le mien, tout peut rentrer, à l'intérieur ou à l'extérieur, je ferai en sorte que ça marche.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans la compagnie!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous dépensez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Couronnes"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 750)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
	}

});

