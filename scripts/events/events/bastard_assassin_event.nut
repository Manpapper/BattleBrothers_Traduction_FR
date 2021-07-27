this.bastard_assassin_event <- this.inherit("scripts/events/event", {
	m = {
		Bastard = null,
		Other = null,
		Assassin = null
	},
	function create()
	{
		this.m.ID = "event.bastard_assassin";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "Intro",
			Text = "[img]gfx/ui/events/event_33.png[/img]Sous le couvert de la nuit, un homme se glisse dans votre tente, sous les plis qui flottent juste au-dessus du sol. Il est masqué avec une cape noire et des pauldrons nobles. Vous vous armez, mais il vous tend la main.%SPEECH_ON%Ne te donne pas la peine, mercenaire, car je ne suis pas là pour toi.%SPEECH_OFF%Ce n\'est pas assez pour vous. À la seconde où l\'homme fait un pas de plus, vous chargez et le plantez sur votre table et avec votre bras libre, vous lui mettez une dague sur le cou. Il sourit.%SPEECH_ON%Je vous l\'ai déjà dit que je ne suis pas là pour vous. Je suis là pour %bastard%.%SPEECH_OFF%Le noble bâtard ? Vous demandez ce que l\'étranger lui veut.%SPEECH_ON%Eh bien, ça dépend, es-tu prêt à parler ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, parlons.",
					function getResult( _event )
					{
						return "A";
					}

				},
				{
					Text = "Pas de discussion. Tu meurs tout simplement.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "Decline1";
						}

						if (r <= 66)
						{
							return "Decline2";
						}
						else
						{
							return "Decline3";
						}
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Assassin = roster.create("scripts/entity/tactical/player");
				_event.m.Assassin.setStartValuesEx([
					"assassin_background"
				]);
				this.Characters.push(_event.m.Assassin.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous soulevez la dague de son cou. Il se redresse sur la table et jette un coup d\'œil à la carte.%SPEECH_ON%Je vois que %companyname% a marché de vastes distances. %bastard% a choisi sagement de s\'intégré dans ses rangs.%SPEECH_OFF%Lorsqu\'une goutte de sang éclabousse le papier, il s\'arrête pour gratter la petite entaille que vous avez laissée sur son cou, en pinçant les lèvres comme s\'il se l\'était fait lui-même lors du rasage du matin....%SPEECH_ON%Bref, passons aux choses sérieuses. Mes mécènes veulent la mort de %bastard%. Vu que j\'ai reçu une grosse somme d\'argent, je suis obligé d\'aller jusqu\'au bout de cette ambition. Ou... peut-être pas.%SPEECH_OFF%Quand il lève un sourcil enjoué, vous lui dites de dire ce qu\'il pense. Il fait avancer une figurine sur la carte pendant qu\'il parle.%SPEECH_ON%%bastard% a une armée qui l\'attend s\'il le souhaite. C\'est pourquoi les nobles veulent sa mort, parce qu\'il représente une menace réelle et viable pour le statu quo, ce qu\'il ne sait pas encore. Je suppose qu\'il n\'a pas à le savoir non plus, mais ce serait un bel adieu, non? Tu dois t\'assurer que sa place dans ce monde est justifiée et qu\'il n\'est pas un accident dans un monde qui, selon lui, le déteste. Mais qu\'en est-il de moi, un assassin extrêmement talentueux avec une série parfaite de meurtres, hm? Et moi, alors ? Eh bien, je ne veux plus de cette vie. Alors voilà mon offre : Je prends sa place. Il rentre chez lui, je rentre avec vous. Il part et conquiert, mes mécèness ne sont pas inquiets et pour ce qu\'ils en savent, j\'ai simplement disparu. Ça sonne bien, non?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous avons un accord.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Combien êtes-vous payé pour cela ?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Ou je vous tuerai.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "Decline1";
						}

						if (r <= 66)
						{
							return "Decline2";
						}
						else
						{
							return "Decline3";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Assassin.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]%bastard% mérite mieux. Non pas que %companyname% soit indigne de lui, mais c\'est un homme qui a passé toute sa vie à se considérer comme un étranger, un fléau pour son propre nom de famille, une menace pour ceux qu\'il aime simplement parce qu\'ils ont une meilleure lignée que lui. Vous accédez à la demande de l\'assassin et faites entrer le bâtard dans votre tente. Quand il le fait, vous lui expliquez rapidement la situation. Il demande une preuve qu\'une armée l\'attend et le tueur à gages s\'exécute rapidement, produisant un parchemin estampillé d\'un sigle et d\'une signature que seul le bâtard pourrait reconnaître. %bastard% le lit attentivement. Il se baisse et vous regarde.%SPEECH_ON%Et vous êtes d\'accord avec ça ? C\'est mon destion, mais vous avez mon épée et mon allégeance aussi longtemps que vous le souhaitez.%SPEECH_OFF%Vous tapez sur l\'épaule de l\'homme et lui dites de tacer son propre chemin. L\'assassin lui dit que s\'il doit le faire, il doit le faire rapidement. Un peu en larmes, et ne cherchant pas du tout à le cacher, %bastard% vous remercie d\'avoir au moins cru en lui, même si ce n\'était que pour le court moment où il était avec %companyname%. Et puis il part. En vous retournant, vous trouvez l\'assassin qui s\'incline.%SPEECH_ON%Et juste comme ça, vous avez mon épée, capitaine.%SPEECH_OFF%Il faudra l\'expliquer aux autres hommes, mais ils feront confiance à votre intuition.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prends soin de toi, salaud.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Assassin);
						this.World.getTemporaryRoster().clear();
						_event.m.Assassin.onHired();
						_event.m.Bastard.getItems().transferToStash(this.World.Assets.getStash());
						this.World.getPlayerRoster().remove(_event.m.Bastard);
						_event.m.Bastard = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Assassin.getImagePath());
				this.Characters.push(_event.m.Bastard.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Bastard.getName() + " quitte " + this.World.Assets.getName()
				});
				this.List.push({
					id = 13,
					icon = "ui/icons/special.png",
					text = _event.m.Assassin.getName() + " rejoint " + this.World.Assets.getName()
				});
				_event.m.Assassin.getBackground().m.RawDescription = "%name% a rejoint la compagnie contre " + _event.m.Bastard.getName() + ". On sait peu de choses sur l\'assassin et la plupart des gens se méfient de lui. Une dague à la main, la main armée du tueur s\'agite et se balance plus comme un serpent que comme un homme.";
				_event.m.Assassin.getBackground().buildDescription(true);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Avant de décider quoi que ce soit, vous demandez à l\'assassin combien il a reçu pour tuer le bâtard. Il calcul le prix en inclinant sa tête d\'un côté à l\'autre.%SPEECH_ON%Eh bien, c\'était... et puis, en déduisant le temps de voyage, le coût de l\'équipement, le temps qu\'il a fallu pour trouver ce satané bâtard, et le temps qu\'il a fallu pour repérer votre campement et savoir si vous seriez ouvert au dialogue, je dirais... cinq mille couronnes. Si vous envisagez de vous aligner, ce sera un peu plus. Environ mille de plus, ce qui fait six mille couronness. Tu es toujours partant pour ce genre de discussion, hein?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'accepte votre offre. %bastard% va partir, et vous allez prendre sa place.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Je vous paierai ces 6000 couronnes, et vous resterez tous les deux, %bastard% et vous.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Je pense que je vais juste te tuer.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 33)
						{
							return "Decline1";
						}

						if (r <= 66)
						{
							return "Decline2";
						}
						else
						{
							return "Decline3";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Assassin.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_33.png[/img]Bien que %companyname% se porte bien, elle pourrait se porter encore mieux et avec six mille couronnes ça ferait beaucoup. Mais... vous êtes d\'accord. L\'assassin entend vos paroles et reste assis un moment.%SPEECH_ON%Tu es d\'accord ? Tu paies six mille couronnes, vraiment ? %SPEECH_OFF% Tu acquiesces. Il réfléchit à ces mots pendant un moment, et fait une légère pause.%SPEECH_ON% Pour être honnête, je ne pensais pas que tu ferais ça. Mais un marché est un marché, et je ne suis pas du genre à jouer avec les mots.%SPEECH_OFF%Il vous tend la main et vous la prenez en la serrant fermement - juste au cas où ce serait une ruse. Il s\'incline gracieusement, sans doute quelque chose qu\'il a appris dans les couloirs des nobles qui l\'ont envoyé ici en premier lieu.%SPEECH_ON%Capitaine de %companyname%, tu as ma lame!%SPEECH_OFF%Il faudra expliquer comment un homme au hasard s\'est glissé dans la compagnie du jour au lendemain, mais les hommes ont suffisamment confiance en votre commandement pour que vous puissiez recruter une chèvre maniant l\'épée et qu\'ils acceptent.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue à bord, assassin.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Assassin);
						this.World.getTemporaryRoster().clear();
						_event.m.Assassin.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Assassin.getImagePath());
				_event.m.Assassin.getBackground().m.RawDescription = "Un assassin fatigué de la vie de tueur, %name% a proposé de rejoindre votre compagnie à un prix élevé que vous avez rapidement égalé. Il est extrêmement habile avec une lame courte, faisant tourner les dagues avec plus de dextérité et de contrôle que certains hommes ont sur leurs propres doigts.";
				_event.m.Assassin.getBackground().buildDescription(true);
				this.World.Assets.addMoney(-6000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous avez dépensé [color=" + this.Const.UI.Color.NegativeEventValue + "]6,000[/color] Couronnes"
				});
				this.List.push({
					id = 13,
					icon = "ui/icons/special.png",
					text = _event.m.Assassin.getName() + " a rejoint " + this.World.Assets.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Decline1",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous refusez l\'offre de l\'assassin. Il acquiesce.%SPEECH_ON%Très bien.%SPEECH_OFF%La dague arrive rapidement, plus vite que vous ne l\'auriez cru. Votre main se lève pour la dévier, mais c\'est un moment trop lent. Le tranchant du couteau touche votre joue et fait couler le sang. Le temps que vous dégainiez votre épée, l\'assassin a déjà bondi hors de la tente. Vous entendez de l\'agitation à l\'extérieur et vous vous y précipitez. %bastard% le bâtard est allongé sur le sol, quelques autres frères d\'armes à côté de lui. %otherbrother% vient demander si vous allez bien. Il dit qu\'un homme en noir a essayé de tuer le bâtard.%SPEECH_ON%Je pense qu\'on l\'a blessé mortellement, mais je ne sais pas où il est allé. L\'assassin nous a tous tailladés. Monsieur, vous saignez.%SPEECH_OFF%Tu lui dis que tu sais et que la priorité pour le moment est de s\'occuper du bâtard et du reste des hommes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, at least no one was killed.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bastard.getImagePath());
				local injury = _event.m.Bastard.addInjury(this.Const.Injury.PiercingBody);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Bastard.getName() + " souffre de" + injury.getNameOnly()
				});
				injury = _event.m.Bastard.addInjury(this.Const.Injury.PiercingBody);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Bastard.getName() + " souffre de " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "Decline2",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous mettez une main sur le pommeau de votre épée et déclinez la demande de l\'assassin. Il frappe dans ses mains.%SPEECH_ON%D\'accord, mercenaire. C\'est juste. Et ne t\'embête pas avec la théâtralité.%SPEECH_OFF%He nods to your sword-hand.%SPEECH_ON%Si je voulais vraiment que le bâtard meure, tu crois que je serais là ? Je suis venu pour parler, et nous avons parlé. La vie de tueur m\'a quitté et avec elle, apparemment, mon visage impassible. Tu as appelé ça mon bluff et je suppose que c\'est comme ça que l\'on peut le voir. Bonsoir, mercenaire.%SPEECH_OFF%Avant que vous ne puissiez dire un mot de plus, l\'assassin sort de la tente. Vous vous précipitez pour voir où il est allé, mais tout ce que vous voyez, c\'est l\'obscurité de la nuit. %bastard% tLe bâtard vous espionne et vous demande ce que vous faites. Vous souriez et lui dites de se reposer car il le mérite bien. Confus, l\'homme hausse les épaules.%SPEECH_ON%Eh bien, euh, je suppose que oui. Merci, capitaine.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'imagine que c\'est tout.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bastard.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Decline3",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous refusez l\'offre de l\'assassin. Il acquiesce, en passant une main sur une bougie.SPEECH_ON%Eh bien. Je suppose que notre conversation est terminée et que quelque chose d\'autre doit commencer.%SPEECH_OFF%Son visage se tourne vers vous. Il vous fait un clin d\'oeil.\n\n La dague arrive rapidement, son éclat brillant alors qu\'elle coupe juste devant votre visage. Vous tendez le bras pour prendre votre épée mais l\'homme vous donne un coup de pied dans la main et renvoie l\'épée dans son fourreau. Une deuxième dague arrive, la vôtre, dégainée derrière votre dos et lancée en avant avec des intentions meurtrières. La dague de l\'assassin se transforme en un trident dans lequel votre lame se prend. Il tourne sa main, vous désarmant en un instant, puis la retourne, refermant la dague en une seule lame. Fils de pute...\n\n L\'homme cherche à vous poignarder, mais vous attrapez son bras. Il vous gêne de sa main libre avant de récupérer une autre lame que vous n\'avez aucun moyen d\'arrêter. Il chuchote avec un calme inquiétant.%SPEECH_ON%Mourez avec grâce, capitaine.%SPEECH_OFF%Alors que sa main recule, elle disparaît soudainement dans un éclat de métal. Tout ce qui reste est un moignon crachant du sang. L\'assassin regarde le moignon et crie. %bastard% se tient là, arme à la main. Un autre coup de métal et la tête de l\'assassin tombe de ses épaules. Un jet de sang s\'écoule du corps, qui heurte la table et le sol. Le bâtard s\'empresse de demander.%SPEECH_ON%Vous allez bien? C\'était qui, bordel?%SPEECH_OFF%D\'autres mercenaires entrent dans la tente pour voir ce qui se passe. Vous leur faites savoir qu\'un assassin était venu pour le bâtard, mais que vous n\'alliez pas le livrer aussi facilement. Les hommes applaudissent votre défense du mercenaire.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu m\'en dois une.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bastard.getImagePath());

				if (!_event.m.Bastard.getSkills().hasSkill("trait.loyal") && !_event.m.Bastard.getSkills().hasSkill("trait.disloyal"))
				{
					local loyal = this.new("scripts/skills/traits/loyal_trait");
					_event.m.Bastard.getSkills().add(loyal);
					this.List.push({
						id = 10,
						icon = loyal.getIcon(),
						text = _event.m.Bastard.getName() + " est maintenant loyal"
					});
				}

				_event.m.Bastard.improveMood(2.0, "Vous avez risqué votre vie pour lui");

				if (_event.m.Bastard.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bastard.getMoodState()],
						text = _event.m.Bastard.getName() + this.Const.MoodStateEvent[_event.m.Bastard.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Bastard.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Vous avez risqué votre vie pour vos hommes");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.bastard")
			{
				candidates.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Bastard = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates.len() * 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bastard",
			this.m.Bastard.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "Intro";
	}

	function onClear()
	{
		this.m.Bastard = null;
		this.m.Other = null;
		this.m.Assassin = null;
	}

});

