this.player_plays_dice_event <- this.inherit("scripts/events/event", {
	m = {
		Gambler = null,
		PlayerDice = 0,
		GamblerDice = 0
	},
	function create()
	{
		this.m.ID = "event.player_plays_dice";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_62.png[/img]Alors que vous vous détendez après la marche du jour, %gambler% s\'approche de vous avec une paire de dés et une tasse à la main. Il vous demande si vous souhaitez faire une petite partie. Les règles sont assez simples : vous lancez les dés dans le gobelet, celui qui a les chiffres les plus élevés gagne. C\'est du pur hasard ! La mise est de vingt-cinq couronnes par lancer de dés."
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jouons !",
					function getResult( _event )
					{
						_event.m.Gambler.improveMood(1.0, "A joué un jeu de dés avec vous");
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "Je n\'ai pas le temps pour ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_62.png[/img]Vous lancez les dés, obtenant un total de %playerdice%.\n\n%gambler% passe ensuite, obtenant un total de %gamblerdice%.\n\n{Eh bien, vous avez perdu. Le parieur reprend les dés - ainsi que vos vingt-cinq couronnes - et vous demande si vous voulez recommencer. | Les dés n\'étaient pas en votre faveur et le parieur prend ses gains. Il vous regarde en souriant.%SPEECH_ON%Vous souhaitez réessayer ?%SPEECH_OFF% | Les numéros sont comptés et, hélas, vous avez perdu. Le parieur vous demande si vous souhaitez recommencer. | Perdu ! Mais peut-être que si vous rejouez... | Vous avez perdu ! Un simple coup de dé, et une simple perte. Mais celle-ci fait beaucoup moins mal que celles que vous avez vues sur les champs de bataille. Le parieur vous demande si vous souhaitez retenter votre chance. | Les dieux vous ont boudés, vous et vos dés stupides. Perdre la partie est un revers mineur, mais votre fierté coûte un peu plus de vingt-cinq couronnes. Devriez-vous rejouer ? | Les probabilités vous ont trahi pour une misérable vingtaine de couronnes. Peut-être que si vous relancez, vous pourrez les regagner ? | Vous regardez vos dés tomber, voyant pendant un instant les numéros gagnants avant qu\'ils ne s\'inclinent et tombent d\'un autre côté, révélant un total perdant. Le parieur rit et vous demande si vous souhaitez relancer le dé. | Votre lancer était parfait ! Comment avez-vous pu perdre ? Il avait juste besoin de ces chiffres pour gagner ! Secouant la tête, vous vous demandez si vous devez relancer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est reparti !",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "J\'en ai assez pour aujourd\'hui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
				this.World.Assets.addMoney(-25);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]25[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_62.png[/img]Vous lancez les dés, obtenant un total de %playerdice%.\n\n%gambler% passe ensuite, obtenant un total de %gamblerdice%.\n\n{Vous avez gagné ! Le parieur tape dans ses mains.%SPEECH_ON%La chance du débutant!%SPEECH_OFF%Vous croisez les bras.%SPEECH_ON%Je pensais que ce n\'était que de la chance?%SPEECH_OFF%Le parieur rit et vous demande si vous voulez tester cette théorie. | Le joueur se penche en arrière.%SPEECH_ON%Et bien, que je sois damné. On recommence!%SPEECH_OFF%. | Le joueur se penche en arrière..%SPEECH_ON%{Eh bien, je serai le cul d\'un cheval ! | Que je sois damné si les dieux ne m\'ont pas tourné le dos. | C\'est un bien mauvais exemple de la chance. | J\'ai couché avec une dame du nom de Luck, et le bien que cela m\'a fait... | C\'est un malheur pour moi. | Hé, c\'est un rouleau gagnant. | Je deviendrais un vagabond. | Putain ! | Chier sur un cochon mouillé | Aussi damné qu\'une nonne sur son dos | Le lancer d\'un maître, je dis | Vous êtes un voleur avec un tel lancer et ouais. | Que %randomtown% rejoigne les orcs | Et ils disent qu\'un écureuil aveugle ne peut pas trouver une noix. | Chatouille-moi l\'anus avec un rosier et appelle-moi Sally Siegfried.}, Vous avez gagné ! C\'est reparti pour un tour!%SPEECH_OFF% | Vous avez gagné ! En riant, vous prenez vos gains et le parieur vous demande si vous souhaitez faire un autre lancer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est reparti !",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "J\'en ai assez pour aujourd\'hui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
				this.World.Assets.addMoney(25);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You win [color=" + this.Const.UI.Color.PositiveEventValue + "]25[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_62.png[/img]Vous lancez les dés, obtenant un total de %playerdice%.\n\n%gambler% lance ensuite, obtenant un total de %gamblerdice%.\n\n Les chiffres sont identiques. Une égalité ! On recommence ?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est reparti !",
					function getResult( _event )
					{
						_event.m.PlayerDice = this.Math.rand(3, 18);
						_event.m.GamblerDice = this.Math.rand(3, 18);

						if (_event.m.PlayerDice == _event.m.GamblerDice)
						{
							return "D";
						}
						else if (_event.m.PlayerDice > _event.m.GamblerDice)
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "J\'en ai assez pour aujourd\'hui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() <= 100)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gambler" || bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.thief" || bro.getBackground().getID() == "background.raider")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Gambler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gambler",
			this.m.Gambler.getName()
		]);
		_vars.push([
			"playerdice",
			this.m.PlayerDice
		]);
		_vars.push([
			"gamblerdice",
			this.m.GamblerDice
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Gambler = null;
		this.m.PlayerDice = 0;
		this.m.GamblerDice = 0;
	}

});

