this.pimp_vs_harlot_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Monk = null,
		Tailor = null,
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.pimp_vs_harlot";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]Vous croisez un homme et une femme qui se disputent devant l\'un des bâtiments de la ville.%SPEECH_ON%Pourquoi est-ce que je vous donne tout ? C\'est moi qui fais tout le travail !%SPEECH_OFF%Elle crie. L\'homme se frotte le menton et répond : %SPEECH_ON% C\'est moi qui domine ta chatte ! Comment pourrais-tu trouver du travail sans moi?%SPEECH_OFF% La femme, en vous voyant, se retourne et vous demande si vous voulez bien coucher avec elle. Elle pourrait avoir la forme de deux cercles et d\'un triangle que vous seriez probablement toujours partant. La femme jette ses mains en l\'air.%SPEECH_ON%Vous voyez ? La moitié de ce monde est prête à faire des affaires si j\'ouvre ne serait-ce que les jambes!%SPEECH_OFF%L\'aspirant maquereau vous demande de ramener à la raison son \"avenir\".",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Les proxénètes vous gardent en sécurité dans ce monde.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Il n\'y a rien de mal à ce qu\'une prostituée joue selon ses propres règles.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "On dirait que notre ménestrel a quelque chose à dire.",
						function getResult( _event )
						{
							return "Minstrel";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Notre moine souhaite-t-il parler de cet... échange?",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Tailor != null)
				{
					this.Options.push({
						Text = "Le tailleur de la compagnie pourrait avoir son mot à dire.",
						function getResult( _event )
						{
							return "Tailor";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_92.png[/img]Vous donnez votre réponse.%SPEECH_ON%Un proxénète assure la sécurité. Ce n\'est pas parce que toutes les bites veulent ce qu\'il y a entre tes jambes que tu es en sécurité. Le plus petit détail peut faire ressortir la nature plus sombre et plus violente d\'un client.%SPEECH_OFF%Le mac hoche la tête.%SPEECH_ON%Écoutez-le !%SPEECH_OFF%Pensant, la prostituée acquiesce avant de gifler soudainement le proxénète. Il crie et frotte la plaie. La femme hoche à nouveau la tête.%SPEECH_ON%Cette lopette est censée me protéger, vraiment ? Bonne journée, messieurs.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Merde. Je pensais qu\'il avait un jeu de maquereau plus fort.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_92.png[/img]Avec un geste paternel, vous prenez le proxénète par l\'épaule.%SPEECH_ON%On peut sortir la femme d\'une pute, mais on ne peut sortir la pute d\'une femme.%SPEECH_OFF%Le proxénète réfléchit. Vous aussi, car vous n\'avez jamais été du genre logique. Le mac te regarde. %SPEECH_ON%Quoi ? %SPEECH_OFF%La dame s\'avance et prend le mac par l\'autre épaule. %SPEECH_ON% Je crois qu\'il veut dire de me relâcher. Comme le maquereau lève un sourcil, la femme clarifie : %SPEECH_ON%Figurativement parlant.%SPEECH_OFF%Le maquereau soupire : %SPEECH_ON%Je ne comprends pas ce que vous dites, mais d\'accord. J\'ai pensé que peut-être je pourrais monter une affaire ici. Une femme par-ci, une femme par-là, je gagne quelques couronnes et prendre une retraite anticipée. Et puis finalement, je retourne moudre du blé pour en faire de la farine jusqu\'à ce que je m\'écroule et que je meure.%SPEECH_OFF% L\'homme s\'en va, son nez reniflant.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le métier de maquereau n\'est pas fait pour tout le monde.",
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
			ID = "Minstrel",
			Text = "[img]gfx/ui/events/event_92.png[/img]%minstrel% le ménestrel s\'avance. %SPEECH_ON%Hum oui, qu\'est-ce que c\'est que cette histoire d\'un abruti et la queue d\'une putain ? D\'un seul regard je sais ce que tu dois faire mon ami : déclarer ton amour éternel à cette jeune femme!%SPEECH_OFF%La femme croise les bras et fronce les sourcils.%SPEECH_ON%Qu\'est ce que tu racontes--%SPEECH_OFF%Le ménestrel l\'écarte du chemin en levant un bras et une voix simple avec.%SPEECH_ON%Ouiii! L\'amour, oui, l\'amour est dans l\'air ! Mieux vaut le laisser s\'enflammer ! - et je ne parle pas seulement de sa queue et de ses couilles. Il t\'aime, ma chère, ne vois-tu pas ? Sinon, pourquoi aurait-il fait de toi une prostituée ? Un proxénète a besoin d\'un nombre de choix diversifié, pas d\'un business d\'une seule sainte-oh, ohhh!%SPEECH_OFF%Le proxénète baisse la tête, le visage rouge et embarrassé. Il admet que c\'est vrai, tout est vrai. La femme se retourne, le visage rougi. Ils se regardent. Vous faites rouler les vôtres. Ils s\'embrassent et partent en amoureux.%SPEECH_ON% Je suis un poète et je ne m\'en suis même pas... rendu compte.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très beau travail, ménestrel.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				_event.m.Minstrel.improveMood(2.0, "Enchanté par sa propre poésie");

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Tailor",
			Text = "[img]gfx/ui/events/event_92.png[/img]\"Tsk, tsk, tks.\" %tailor% le tailleur se pavane en secouant la tête. Il passe un doigt le long de la robe de la prostituée. Il fait remarquer qu\'il pensait que les putes étaient censées être jolies. Le proxénète lève la main : %SPEECH_ON% C\'est sur ma propriété que vous crachez. %SPEECH_OFF%%tailleur% s\'incline : %SPEECH_ON%Pardon, monsieur, mais je crois que vous avez déjà craché sur elle en l\'habillant de cette façon. Je ne saurais pas qu\'elle cherche l\'argent d\'une putain si vous ne lui aviez pas crié dessus avec le sens de l\'économie d\'un maquereau.%SPEECH_OFF%Le maquereau sort un poignard et attaque. Le tailleur pirouette, virevoltant sous le coup de la lame. Il se redresse et plante une paire de ciseaux épais sur la gorge du proxénète.%SPEECH_ON%Mmm, quelle drôle de position. J\'ose dire que vous n\'avez que deux issues, et l\'une est beaucoup plus brillante que l\'autre. Oui, c\'est ça, vous avez compris, n\'est-ce pas ? Payez ou je vous tranche la gorge et les couilles et l\'ordre dans lequel je le fais pourrait vous surprendre.%SPEECH_OFF%Le maquereau s\'empresse de donner quelques couronnes pour qu\'il épargner sa vie. Le tailleur referme ses ciseaux et les empoche.%SPEECH_ON%Bien. Maintenant, quelques conseils. Vous pouvez trouver du linge de maison pour pas cher dans la rue là-bas. L\'homme qui travaille dans cette boutique est, hm, particulièrement doué pour habiller les femmes... et les hommes. Allez allez maintenant.%SPEECH_OFF%%tailleur% se tourne vers vous avec un sourire et demande s\'il peut aller visiter quelques magasins pour dépenser son or nouvellement gagné.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(100, 200);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				_event.m.Tailor.getBaseProperties().Initiative += 2;
				_event.m.Tailor.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/initiative.png",
					text = _event.m.Tailor.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] d\'Initiative"
				});
				this.Characters.push(_event.m.Tailor.getImagePath());
				_event.m.Tailor.improveMood(1.0, "A Réduit l\'égo d\'un maquereau");

				if (_event.m.Tailor.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tailor.getMoodState()],
						text = _event.m.Tailor.getName() + this.Const.MoodStateEvent[_event.m.Tailor.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_92.png[/img]Le moine s\'avance. Il prend le maquereau par les mains. Si vous faisiez cela, le maquereau reculerait sans doute ou vous frapperait. Mais le saint homme le fait avec tant de grâce et d\'humilité que le proxénète se contente de le regarder fixement. Le moine sourit chaleureusement.%SPEECH_ON% Ce n\'est pas une voie pour vous, c\'est clair. Vous n\'avez pas les moyens de vous occuper de cette femme, et ce n\'est qu\'une seule femme, alors qu\'un proxénète en a besoin de plusieurs. Les vieux dieux me disent que vous êtes destiné à un autre chemin, un chemin qui est pour les hommes plus robustes. J\'ose dire que vous êtes fait pour une compagnie de mercenaires. Laissez les femmes à ceux qui savent manier les serpents.%SPEECH_OFF% Le mac réfléchit un moment, mais vous pouvez voir que les mots l\'ont atteint. Il demande si vous l\'accepteriez dans votre compagnie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, on vous emmène.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Non, merci.",
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
				_event.m.Monk.improveMood(1.0, "A ramené un homme sur le droit chemin.");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Monk.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"pimp_background"
				]);
				_event.m.Dude.setTitle("the Pimp");
				_event.m.Dude.getBackground().m.RawDescription = "While visiting " + _event.m.Town.getName() + ", you found %name% quarreling with his only harlot. " + _event.m.Monk.getName() + " persuaded him to join the company and you agreed to take him along. Hopefully, he\'s better fighting in the shield wall than he is wrangling whores.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && !t.isMilitary() && !t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_minstrel = [];
		local candidate_monk = [];
		local candidate_tailor = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidate_minstrel.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.tailor")
			{
				candidate_tailor.push(bro);
			}
		}

		if (candidate_minstrel.len() != 0)
		{
			this.m.Minstrel = candidate_minstrel[this.Math.rand(0, candidate_minstrel.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_tailor.len() != 0)
		{
			this.m.Tailor = candidate_tailor[this.Math.rand(0, candidate_tailor.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"tailor",
			this.m.Tailor != null ? this.m.Tailor.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Minstrel = null;
		this.m.Tailor = null;
		this.m.Dude = null;
		this.m.Town = null;
	}

});

