this.pimp_and_harlots_event <- this.inherit("scripts/events/event", {
	m = {
		Payment = 0
	},
	function create()
	{
		this.m.ID = "event.pimp_and_harlots";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]Pendant la marche, vous rencontrez une femme qui se tient sur le bord de la route. Elle se tient à la tête d\'un chariot tiré par un âne. En vous voyant, elle frappe dans ses mains et crie un ordre. En quelques instants, des servantes sortent de l\'arrière du chariot et s\'alignent devant vous. Elles sont mal habillées et, s\'il s\'agit d\'une pièce de théâtre, mal répétées. La plupart ont l\'air de vouloir être ailleurs, ce qui est normal pour toute femme coincée dans la cambrousse. Vous demandez à la \"chef\" de ce groupe ce qu\'elle fait. Elle sourit d\'une oreille à l\'autre.%SPEECH_ON%Je suis une marchande de chair, une profiteuse de bons coups. Voici, ici, ma marchandise.%SPEECH_OFF%Elle balance ses bras vers les prostituées. Elles se redressent, ou se relâchent, et feignent de s\'intéresser à vous et à vos hommes. La proxénète hoche la tête. %SPEECH_ON%Alors, que diriez-vous de nous aider à nous détendre, hm ? La journée a été longue, non ? Pour autant d\'hommes, je parierais que ça ne vous coûterait qu\'un faible montant de %cost% couronnes.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Vous avez un marché !",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "Et si vous donniez vos objets de valeur à la place ?",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Non, merci.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]Malgré les protestations de certains de vos hommes, vous refusez l\'offre de la maquerelle. Elle hausse les épaules. %SPEECH_ON%Mince, je savais que j\'aurais dû investir dans des petits garçons. Eh bien, faites comme vous voulez.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il y aura du divertissement dans la prochaine ville.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(0.75, "Vous avez refusé de payer pour des prostituées");

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
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_85.png[/img]Les femmes se pressent, certaines clignent des yeux paresseusement, d\'autres avec des yeux paresseux. C\'est un bien triste groupe de femmes, mais les hommes ont besoin d\'un peu de répit. Vous acceptez le prix du proxénète et les hommes s\'occupent du reste, en se cachant dans les buissons et divers autres abris. Pendant qu\'ils ont de l\'action, la maquerelle s\'approche de vous : %SPEECH_ON%Merci de ne pas nous avoir volés%SPEECH_OFF%Vous haussez les épaules et dites que c\'est toujours sur la table. Elle hausse les épaules aussi. %SPEECH_ON% Je sais, mais je ne pense pas que vous le ferez. Vous et moi, on se ressemble beaucoup. Vous vous battez pour la nourriture, on baise pour ça.%SPEECH_OFF% Curieux, vous lui demandez si elle \"baise\" toujours pour sa nourriture. Elle rit.%SPEECH_ON%Seulement quand j\'en ai besoin. Ce rôle de \"leader\" est plutôt sympa. Vous vous battez toujours pour la vôtre ?%SPEECH_OFF% Vous lui dites juste la vérité.%SPEECH_ON% J\'ai tué beaucoup, beaucoup de gens.%SPEECH_OFF% Elle s\'approche de très près maintenant et donne un coup de main bas.%SPEECH_ON%Eh bien%SPEECH_OFF% Eh bien effectivement.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça en valait la peine.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "S\'est amusé avec des prostituées");

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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_07.png[/img]Vous acceptez l\'offre. La proxénète et ses prostituées s\'avancent, s\'engouffrant dans vos rangs comme une bande de serpents salaces. Quelques instants après que la plupart de vos hommes aient baissé leur pantalon, un groupe de bandits sort des buissons. Vous saisissez votre épée, la vraie, et, à mains nues, retirez la tête d\'un voleur de son épaule et poignardez un autre dans la poitrine. D\'autres voleurs s\'avancent, armes sorties, prêts au combat, mais le mac saute entre tous.%SPEECH_ON%Whoa ! Personne d\'autre n\'a besoin de mourir ici !%SPEECH_OFF%Certains de vos hommes ne se rendent toujours pas compte de ce qui se passe, ce qui est un bon signe que cette femme a pris le dessus sur vous. Cela dit, %companyname% est toujours une force de la nature, pantalon ou pas, et la proxénète le reconnaît. Elle réprimande les bandits.%SPEECH_ON%Je croyais vous avoir dit, bande de crétins, de ne pas attaquer si les clients semblent dangereux. N\'ont-ils pas l\'air foutrement dangereux ? Bon sang. Ecoute, mercenaire. Je prends le double de l\'offre et je te laisse tranquille. Doublez juste l\'offre et on s\'en va.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "D\'accord, marché conclu.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Pas de marché.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_07.png[/img]Vous n\'allez pas risquer vos hommes et accepter ses conditions. Prenant l\'argent, elle hoche la tête. %SPEECH_ON%La plupart des hommes auraient laissé leur fierté prendre le dessus, mais vous savez comment assurer la sécurité de vos hommes. Un mercenaire intelligent est rare de nos jours et vos hommes devraient être heureux de vous avoir comme chef.%SPEECH_OFF%Alors que les voleurs et les prostituées partent, %randombrother% s\'approche en gémissant.%SPEECH_ON%Bon sang. Je suis tellement chaud que je pourrais fendre une fille en deux.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je n\'avais pas besoin de savoir ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment * 2);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment * 2 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_06.png[/img]Vous ne dites pas \"non\" mais vous le montrez. L\'épée toujours en main, vous la remontez et tailladez le visage de la maquerelle. Alors qu\'elle vous regarde avec incrédulité, vous inversez le mouvement de l\'épée et lui coupez la tête. Les hommes, pantalons baissés, prennent leur équipement et commencent à se battre. Quelques prostituées brandissent des dagues et donnent quelques coups de couteau, mais elles sont rapidement tuées. La plupart des prostituées sont inoffensives, mais se font massacrer dans la confusion et le chaos.\n\n Les voleurs, qui ne s\'attendaient probablement pas à un vrai combat, disent adieu à leur courte vie de merde. En fin de compte, il y a une bonne vingtaine de corps éparpillés sur le terrain et la plupart des mercenaires ne sont pas sortis indemnes de l\'autre côté. Vous essayez de récupérer ce que vous pouvez sur le terrain.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On devrait probablement éviter de se battre avec nos pantalons baissés.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/bludgeon");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(100, 300);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " souffre de " + injury.getNameOnly()
						});
					}
					else
					{
						local injury = bro.addInjury(this.Const.Injury.PiercingBody);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " souffre de " + injury.getNameOnly()
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_07.png[/img]Vous réfléchissez à l\'offre, puis vous réalisez qu\'il ne s\'agit que d\'un groupe de femmes au milieu de nulle part. D\'une main ferme, vous envoyez la proxénète au sol. Elle se frotte la joue et dit que la brutalité sera en supplément. Vous acquiescez.%SPEECH_ON%Ouais, ça va vous coûter tout ce que vous avez. Les gars, prenez tout.%SPEECH_OFF%La proxénète demande si c\'est un vol et vous acquiescez. A la seconde où vous expliquez clairement vos intentions, un groupe d\'hommes armés sortent des buissons voisins. La maquerelle se lève et se frotte la joue.%SPEECH_ON%Je suis toujours prêet à me séparer en termes neutres, mercenaire. Une bonne gifle n\'est pas un problème dans ce business. C\'est même attendu, mais c\'est aussi le cas des voleurs, des meurtriers et des violeurs. Maintenant, si vous voulez continuer à faire ce que vous voulez, je vais envoyer ces hommes contre vous pour faire ce dont j\'ai besoin, c\'est à dire assurer ma sécurité et celle des miens.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "D\'accord, on se retire.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Ces gardes sont pathétiques. Attaquez !",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_64.png[/img]En regardant les gardes et vos hommes que vous ne voulez pas perdre à cause de ces conneries, vous hochez la tête. Très bien. Il n\'y a pas besoin d\'effusion de sang. %SPEECH_OFF%La maquerelle soupire de soulagement. %SPEECH_ON%Content que nous puissions arriver à un accord. J\'ai bien peur que mon offre précédente ne soit plus valable. Je suis sûr que vous comprenez. En rengainant votre épée, vous dites que vous comprenez. Quelques-uns des frères crachent et secouent la tête. Ils pensent qu\'ils ont raté un bon coup à cause de votre agressivité.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Vous ne vous rendez pas compte qu\'ils voulaient nous voler ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "A raté un bon coup à cause de vous.");

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
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_60.png[/img]Ces gardes ne sont que de la merde. Vous ordonnez à vos hommes d\'attaquer. Le combat est un bref tourbillon d\'action. Les mercenaires de la prostituée agissent comme s\'ils ne s\'attendaient pas à voir un vrai combat. Une fois le combat terminé, vous constatez que le chariot est toujours là, mais que la maquerelle et ses prostituées sont parties. Elles ont dû partir pendant le combat. Elles ont même pris l\'âne, cet âne chanceux.\n\n Vos hommes font une descente dans le wagon. En prenant tout ce qui n\'est pas cloué, %randombrother% entend un bruit de coups. Il fouille le fond du chariot et tire sur une corde, faisant tomber une latte de bois sur laquelle roule un homme entièrement recouvert de cuir noir. On retire le masque qui recouvre son visage. Il aspire un souffle.%SPEECH_ON%Merci ! Par les vieux dieux, je pensais qu\'ils allaient me garder là-dedans pour toujours!%SPEECH_OFF% Vous demandez qui il est. Il recrache les morceaux de cuir de sa bouche.%SPEECH_ON%Gimp.%SPEECH_OFF%Juste \'Gimp\' ? Il hoche la tête. %SPEECH_ON%Oui monsieur. Hey, ce sont de belles armes que vous avez là. Une armure élégante, aussi. Hm. Mon maître est parti, alors...%SPEECH_OFF% Vous secouez la tête.%SPEECH_ON% Va à la ville la plus proche et nettoie toi, étranger.%SPEECH_OFF% Il hoche la tête.%SPEECH_ON% Comme vous voulez, maître.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Oui, oui. Allez-y.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/bludgeon");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(100, 300);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " souffre de " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " souffre de blessures légères"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 10)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() <= 3)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 50 * brothers.len() * 2 + 500)
		{
			return;
		}

		this.m.Payment = 50 * brothers.len();
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cost",
			this.m.Payment
		]);
	}

	function onClear()
	{
		this.m.Payment = 0;
	}

});

