this.strange_scribe_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Dude = null,
		Minstrel = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.strange_scribe";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Alors que vous déambuler dans %townname%, vous êtes abordé par une personne que vous aviez vue en compagnie d\'un des nobles de la région. Son visage est enfoui dans sa cape noire. Il est la définition même de la méfiance. Naturellement, %anatomiste% l\'anatomiste le regarde comme s\'il était l\'un de ses sujets de travail. L\'homme s\'incline.%SPEECH_ON%Je suis venu avec un profond respect pour le travail que vous faites, %anatomiste%. Nous avons lu beaucoup de vos textes.%SPEECH_OFF%Vous mettez une main sur le manche de votre épée et attendez de voir où cela va vous mener. L\'homme continue.%SPEECH_ON%Nous aimerions vous inviter à prendre un repas pour discuter de certaines choses en lien avec la physiologie...%SPEECH_OFF%En vous interposant entre les hommes, vous demandez qui est ce \"nous\". L\'homme déclare qu\'il fait partie d\'un groupe de scribes et d\'érudits qui étudient les questions relatives au corps humain. Cela concerne aussi bien nous que le monstres.%SPEECH_ON%Nous avons, bien sûr, un intérêt particulier pour les hommes qui sont devenus bêtes par la suite.%SPEECH_OFF%Avec autant de mystères, il n\'est pas surprenant que l\'anatomiste veuille suivre l\'étrange scribe.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je viens avec vous.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "C\'est bien trop suspect.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "Est-ce que %minstrel% le ménestrel sait quelque chose?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Killer != null)
				{
					this.Options.push({
						Text = "Attendez, où est notre meurtrier %killer%?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Si %anatomist% souhaite se rendre dans cette ville, il ne va sûrement pas y aller seul. Vous le suivez, votre main ne quittant jamais votre épée. L\'homme étrange vous invite à vous rendre dans une belle maison en pierre, éclairée par des bougies aux fenêtres. A l\'intérieur, vous êtes rapidement conduit à ce qui devrait être une table de dîner, mais à la place, vous trouvez un homme pâle dont la peau se détache de son propre corps. L\'étrange scribe s\'incline comme un chef qui a servi son meilleur repas.%SPEECH_ON%Nous pensons qu\'il s\'agit d\'un wiederganger, un homme qui est mort mais qui remarche.%SPEECH_OFF%L\'étrange scribe retrousse sa manche et la tient au-dessus du cadavre décrépit. Sa gueule s\'ouvre soudainement de gauche à droite, la mâchoire est désarticulée, ses yeux blancs roulent sur eux-mêmes. %anatomist% se penche simplement en arrière et mentionne que c\'est \"intéressant\". Les deux hommes se mettent à discuter, tandis que vous tenez fermement le manche de votre épée au cas où ce \"wiederganger\" aurait envie de s\'échapper. Lorsque les deux hommes ont terminé, %anatomiste% et le scribe prennent des plumes d\'oie et apposent leurs signatures sur leurs tomes respectifs, tout en se félicitant mutuellement de leur travail.\n\nToute cette affaire vous fait frémir. Vous remarquez ce qui ressemble à une perle de sueur sur le front du wiederganger, mais avant que vous puissiez faire un commentaire, on vous fait sortir de la maison. Quoi qu\'ils aient discuté, l\'anatomiste est plein de dynamisme. Il parle avec précaution.%SPEECH_ON%La créature était une imposture, bien sûr, ne croyez pas que je ne l\'ai pas remarqué. Cependant, cela m\'a donné un aperçu de la créativité des habitants. Il y a quelque chose à tirer d\'une telle inventivité. Étant donné que l\'imagination de chacun puise subrepticement dans le sublime et le réel et fait des déductions sur ce qu\'elle pressent sans savoir comment décrire une telle précision scientifique, alors je peux moi-même faire de grandes avancées.%SPEECH_OFF%Vous mentionnez que vous saviez que c\'était une fraude parce que le crétin supposé mort transpirait. L\'anatomiste acquiesce et vous dit que vous n\'avez peut-être pas l\'œil pour les enquêtes et les diagnostics, mais vous avez l\'intelligence de la rue.. Vous hochez simplement la tête, en espérant qu\'il a bien voulu dire ce qu\'il voulait dire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Partons d\'ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(0.75, "Learned how to better deal with the laity");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				local fatigueBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Stamina += fatigueBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigueBoost + "[/color] Fatigue"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous acceptez de laisser partir l\'anatomiste, mais vous le suivez. Cela attire l\'attention de l\'étrange scribe. Il semble maintenant réticent à l\'égard de l\'affaire, ayant perdu l\'énergie qu\'il avait lors de ses premières invitations. Au détour d\'un virage, il lance un cri aigu qui ressemble à un oiseau, quelques hommes sortent de leur habitation, vous dégainez votre épée et mettre %anatomist% sous votre protection. L\'un d\'eux tente d\'attaquer. Vous n\'êtes pas très en forme ces jours-ci, mais d\'une parade rapide, vous le faites reculer et le dissuadez de poursuivre son attaque. Le scribe et ses sbires fuient alors précipitamment en disant que vous n\'en valez pas la peine. %anatomiste% a l\'air déçu.%SPEECH_ON%Ah, je vois. C\'était donc une arnaque, une tentative aussi créative que criminelle.%SPEECH_OFF%En y regardant mieux, vous vous rendez compte que votre porte-monnaie a disparu. Un enfant est en train de le lancer à l\'un de ses amis situé sur le rebord d\'une fenêtre. %anatomiste% se tient à côté de vous, levant les yeux au ciel, fasciné par l\'effort d\'ingénierie fourni par ces gamins.%SPEECH_ON%Il semble que là où un délinquant échoue, un autre réussi. C\'est donc par attrition que les criminels peuvent réussir. Intéressant.%SPEECH_OFF%L\'anatomiste se rend soudain compte qu\'il est aussi un peu léger sur la hanche et voit que son sac à main a lui aussi été dérobé. Vous passez devant lui pour voir un autre enfant qui s\'enfuit comme un rat avec son fromage. Un autre enfant passe en courant et essaie de vous détrousser alors qu\'il n\'y a plus rien à voler. Fâché, le garçon répond en hurlant.%SPEECH_ON%Trouve-toi un travail!%SPEECH_OFF%En soupirant, vous dites qu\'il est probablement temps de retourner au sein de votre compagnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maudits garnements",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-175);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]175[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Vous acceptez de laisser parler %anatomiste% et l\'étrange scribe, mais avant même que vous ne puissiez vous diriger vers la rue, %minstrel% le ménestrel s\'avance, souriant et pointant du doigt le scribe.%SPEECH_ON%%fakescribe%! Qu\'est-ce que vous faites en ce moment? C\'est une nouvelle arnaque que vous avez dans votre manche, hein?%SPEECH_OFF%L\'étrange scribe se racle la gorge. Il jette ses mains en l\'air et s\'éclaircit à nouveau la gorge, il semble prêt à parler profondément d\'un sujet mais il soupire et rejette sa cape en arrière. Un jeune homme un peu benêt apparait. Il secoue la tête.%SPEECH_ON%La vie a été dure dans cette grande ville, %minstrel%. Et vous, comment ça va?%SPEECH_OFF%Ils discutent pendant un moment tandis que vous et %anatomist% regardez, déconcertés. Finalement, les deux ménestrels se tournent vers vous, %minstrel% ouvrant la voie.%SPEECH_ON%Capitaine, voici %fakescribe%. Il vit des moments difficiles ici à %townname%. Et s\'il venait avec nous avec la compagnie %companyname%? Il est un peu comme moi, un combattant de merde, mais un homme plein d\'entrain, un homme qui a tout ce qu\'il faut si on lui donne le temps de le trouver, surtout si une femme est impliquée.%SPEECH_OFF%%fakescribe% secoue la tête.%SPEECH_ON%Ehem, ehh, avec eux je n\'ai jamais, euh, trouvé.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien sûr, il peut venir.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Nous n\'avons pas besoin d\'un autre charlatan.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"minstrel_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "{%name% a été trouvé déployant ses talents de ménestrel dans des escroqueries de rue. Recommandé par un collègue ménestrel, il a rejoint le %companyname% pour chercher une vie sur la route. Espérons que le charlatan devenu mercenaire pourra 'faire semblant jusqu'à ce qu'il réussisse', comme il aime le dire un peu trop souvent.}"
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Vous acceptez de prendre le ménestrel sans devoir payer quoi que ce soit. %anatomiste% l\'anatomiste a l\'air un peu maussade à propos de toute l\'affaire, disant qu\'il aspire à la connaissance mais que tout ce que ce monde semble avoir à offrir sont des arnaques et des mensonges. En souriant, vous lui dites de considérer l\'ecole de la rue comme une connaissance. Il sourit à son tour.%SPEECH_ON%Oui, peut-être que je devrais acquérir plus de ces... talents.%SPEECH_OFF%Non, \"connaissances\". \"Talents\" est ridicule à côté. }",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ressaisis-toi, %anatomiste%.",
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
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_12.png[/img]{En vous joignant à eux, vous acceptez de laisser l\'anatomiste et l\'étrange scribe discuter. L\'homme vous emmène aux abords ruelle relativement suspecte. Il se retourne avec un large sourire sur le visage et commence lentement à dégainer une dague de sa manche, puis soudain un couteau lui transperce le visage. Alors qu\'il titube, un autre couteau vient lui trancher la gorge d\'un coup sec. %killer%, le tueur présumé en fuite, apparaît dans la ruelle.%SPEECH_ON%Hey capitaine et, eh, anatomiste? fossoyeur? Ce type était un meurtrier. Empiétant sur mes... euh... affaires.%SPEECH_OFF%Il laisse tomber le corps au sol et commence à soulever la cape pour révéler que ce supposé scribe était en fait bien armé et équipé. Le tueur coupe une des oreilles et l\'emporte, puis il hoche la tête.%SPEECH_ON%Hé, on dirait qu\'on a du matos gratuit, hein? Nous devrions probablement cacher le corps par contre. Cet homme a l\'air d\'être assez important et certains pourraient trouver que son absence mérite une enquête.%SPEECH_OFF%Vous ne savez pas à qui ou à quoi faire confiance, mais un cadavre qui se vide de son sang sur vos bottes a tendance à faire mauvais effet, quelles que soient les circonstances. Vous cachez le corps après l\'avoir débarrassé de son équipement. %anatomist% semble se méfier de %killer%. Il mentionne que le ton de la voix du tueur en cavale semblait être fausse ou comme dirait un profane, \"de la comédie\". Peu importe, ce qui est fait est fait, vous lui demandez simplement de vous aider à transporter le matériel jusqu\'au stock.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est ce qu\'il est censé être.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.75, "Witnessed a brutal murder");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				local attackBoost = this.Math.rand(1, 3);
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Killer.getBaseProperties().MeleeSkill += attackBoost;
				_event.m.Killer.getBaseProperties().Bravery += resolveBoost;
				_event.m.Killer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Killer.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attackBoost + "[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Killer.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});
				local armors = [
					"armor/padded_leather",
					"armor/patched_mail_shirt",
					"armor/leather_lamellar"
				];
				local weapons = [
					"weapons/dagger",
					"weapons/dagger",
					"weapons/dagger",
					"weapons/rondel_dagger"
				];
				local armor = this.new("scripts/items/" + armors[this.Math.rand(0, armors.len() - 1)]);
				armor.setCondition(this.Math.max(1, armor.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(armor);
				this.List.push({
					id = 10,
					icon = "ui/items/" + armor.getIcon(),
					text = "You gain " + armor.getName()
				});
				local weapon = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				weapon.setCondition(this.Math.max(1, weapon.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(weapon);
				this.List.push({
					id = 10,
					icon = "ui/items/" + weapon.getIcon(),
					text = "You gain " + weapon.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Vous dites que la situation est bien trop suspecte pour être tentée. %anatomiste% dit que toute connaissance semble suspecte aux laïcs. Vous lui dites que ce \"profane\" en sait assez pour flairer un rat. L\'anatomiste est contrarié, mais vous préférez qu\'il soit perturbé plutôt que mort.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous feriez mieux de vous réveiller, gros malin.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary() || t.getSize() < 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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
		local anatomistCandidates = [];
		local minstrelCandidates = [];
		local killerCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.minstrel")
			{
				minstrelCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killerCandidates.push(bro);
			}
		}

		if (minstrelCandidates.len() > 0)
		{
			this.m.Minstrel = minstrelCandidates[this.Math.rand(0, minstrelCandidates.len() - 1)];
		}

		if (killerCandidates.len() > 0)
		{
			this.m.Killer = killerCandidates[this.Math.rand(0, killerCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getName() : ""
		]);
		_vars.push([
			"fakescribe",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Dude = null;
		this.m.Minstrel = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});

