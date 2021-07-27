local gt = this.getroottable();

if (!("Contracts" in gt.Const))
{
	gt.Const.Contracts <- {};
}

gt.Const.Contracts.Overview <- [
	{
		ID = "Overview",
		Title = "Vue d\'Ensemble",
		Text = "Le contrat que vous avez négocié est le suivant. Acceptez-vous ces conditions?",
		Image = "",
		List = [],
		Options = [
			{
				Text = "J\'accepte ce contrat.",
				function getResult()
				{
					this.Contract.setState("Running");
					return 0;
				}

			},
			{
				Text = "Il faut que j\'y réfléchisse encore un peu.",
				function getResult()
				{
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			},
			{
				Text = "Après mûre réflexion, je décline ce contrat.",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			}
		],
		ShowObjectives = true,
		ShowPayment = true,
		ShowEmployer = true,
		ShowDifficulty = true,
		function start()
		{
			this.Contract.m.IsNegotiated = true;
		}

	}
];
gt.Const.Contracts.NegotiationDefault <- [
	{
		ID = "Negotiation",
		Title = "Négociations",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "J\'accepte votre offre.",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getInAdvance() + " Couronnes d\'avance");
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getOnCompletion() + " Couronnes quand le travail sera fait");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "Nous avons besoin d\'être payés d\'avantage pour cela.",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "Nous avons besoin d\'une avance." : "Nous avons besoin de plus d\'avance.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;
							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
							this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "Nous avons besoin d\'un paiement une fois le travail accompli." : "Nous avons besoin d\'être payés plus une fois le travail accompli.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;
							this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "Oubliez, ça ne vaut pas le coup.",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});

			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{He nods.%SPEECH_ON%Oui. Hé bien. Je réflèchissais justement à votre paiement pour la tâche un peu plus tôt. | Il se redresse.%SPEECH_ON%Alors, pour le paiement. | Il sourit.%SPEECH_ON%Cela fera de vous un homme riche, mon ami. | Il inspire profondément.%SPEECH_ON%Très bien, c\'est ce que je suis prêt à vous offrir. | Il pose sa main sur votre épaule, en vours souriant.%SPEECH_ON%Je pense avoir une compensation adéquate pour vos services. | Il bouge ses mains dans tous les sens, en pointant ses doigts comme s\'il comptait quelque chose, mais ça ne veut rien dire pour vous.%SPEECH_ON%À en jugé par votre expérience, c\'est un bon prix pour la tâche. | Il hoche de la tête. %SPEECH_ON%Vous semblez capable, donc je suis prêt à payer un peu. | Il fait du bruit avec un sac de pièces.%SPEECH_ON%Elles seront votre si vous m\'aidez. | Il ouvre la paume de sa main.%SPEECH_ON%Je suis à sec, donc avant que vous ne demandiez, c\'est tout ce que j\'ai en ce moment. | %SPEECH_ON%Soyez rassuré ce que je vous offre maintenant est un bon prix pour votre travail.} ";
				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%Je refuse de payer plus que cela. | %SPEECH_START%Soyez Raisonnable. | %SPEECH_START%Non, non, non. | %SPEECH_START%Qui pensez-vous être? Je vous dit comment vous serez payé. | Il vous regarde sévèrement et secoue la tête.%SPEECH_ON% | %SPEECH_START%Il y a pas moyen!%SPEECH_OFF%Il hurle, explosant de colère.%SPEECH_ON% | %SPEECH_START%Non, vous avez déjà plus que ce que vous valez. | %SPEECH_START%Non. Ne me poussez pas à bout! | %SPEECH_START%Je ne pense pas que vous compreniez comment ça fonctionne. Vous devrez faire avec ce que je veux vous payer pour cela. Mon offre initiale tient toujours. }";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%C\'est bon maintenant? | Il inspire profondement.%SPEECH_ON% | Il soupire.%SPEECH_ON% | %SPEECH_START%C\'est valable. | %SPEECH_START%Bien, bien. | %SPEECH_START%S\'il doit en être ainsi. | %SPEECH_START%Très bien. Que dites-vous de cela? | %SPEECH_START%Bien sûr, bien sûr, je comprend. | %SPEECH_START%Raisonable. | %SPEECH_START%Intéressant. Je pense que cela devrait être plus approprié. | %SPEECH_START%Accepteriez-vous cela plutôt? | %SPEECH_START%Laissez-moi proposer l\'offre suivante. | %SPEECH_ON%Bien. Accepteriez-vous cela plutôt? | %SPEECH_START%Très bien. Compte tenu de votre demande je vous propose cela. | %SPEECH_START%Finissons-en rapidement. Voilà ma nouvelle offre. | %SPEECH_START%On est tous amis ici, n\'est-ce pas ? Voyons voir... }";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_completion% Couronnes quand le travail sera fait.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé} %reward_advance% Couronnes d\'avance.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_advance% Couronnes d\'avance, et %reward_completion% quand le travail sera fait.%SPEECH_OFF%";
			}
			else
			{
				this.Text += " Vous ne serez pas payé. C\'est ce que vous voulez?%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "Négociations",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%Vous agissez comme si vous étiez les seuls à tenir une épée pour des pièces. Je pense que je vais allez regarder autre part pour les hommes dont j\'ai besoin. Bonne journée.%SPEECH_OFF% | %SPEECH_START%Ma patience a ses limites, je pense que je perds mon temps ici.%SPEECH_OFF% | %SPEECH_START%J\'en ai eu assez! Je suis sûr que je trouverais quelqu\'un d\'autre pour faire le travail!%SPEECH_OFF% | %SPEECH_START%N\'insultez pas mon intelligence! Oubliez tout à propos de ce contrat. On en a fini.%SPEECH_OFF% | Sa tête devient rouge de colère.%SPEECH_ON%Sortez d\'ici, je n\'ai pas pour habitude de faire affaire avec des démons cupides!%SPEECH_OFF% | Il soupire. %SPEECH_ON%Juste... Oubliez. Je n\'aurais pas du vous faire confiance en premier lieu. Laissez moi que je puisse trouver d\'autres personnes plus sensible .%SPEECH_OFF% | %SPEECH_START%Je pensais vraiment que nous avions une bonne relation. Mais je sais que je ne peux pousser plus loin. je ne pense pas que ça marchera. Je  m\'en vais.%SPEECH_OFF% | %SPEECH_START%Ça a été une totale perte de temps pour moi. Ne vous embêtez pas à revenir tant que vous n\'aurez pas un minimum de raison.%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "Nous ne risquerons pas nos vies pour une paie si basse...",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "Contract negotiations turned sour");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];
gt.Const.Contracts.NegotiationPerHead <- [
	{
		ID = "Negotiation",
		Title = "Négociations",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "J\'accepte votre offre.",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getInAdvance() + " Couronnes d\'avance");
					}

					if (this.Contract.m.Payment.Count != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getPerCount() + " Couronnes par tête que vous ramenez, jusqu\'à un maximum de " + this.Contract.m.Payment.MaxCount);
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getOnCompletion() + " Couronnes quand le travail sera fait");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "Nous avons besoin d\'être payés plus pour ça.",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Count < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Count == 0 ? "Nous avons besoin d\'être payés plus par tête que nous ramenons." : "Nous avons besoin d\'être payés plus par tête que nous ramenons",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
							}
							else if (this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Count = this.Math.minf(1.0, this.Contract.m.Payment.Count + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "Nous avons besoin d\'un paiement en avance." : "Nous avons besoin de plus d\'avance.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "Nous avons besoin d\'un paiement une fois le travail accompli." : "Nous avons besoin d\'être payés plus une fois le travail accompli.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Advance > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}

							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "Oubliez, ça n\'en vaut pas le coût.",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});

			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{He nods.%SPEECH_ON%Oui. Hé bien. Je réflèchissais justement à votre paiement pour la tâche un peu plus tôt. | Il se redresse.%SPEECH_ON%Alors, pour le paiement. | Il sourit.%SPEECH_ON%Cela fera de vous un homme riche, mon ami. | Il inspire profondément.%SPEECH_ON%Très bien, c\'est ce que je suis prêt à vous offrir. | Il pose sa main sur votre épaule, en vours souriant.%SPEECH_ON%Je pense avoir une compensation adéquate pour vos services. | Il bouge ses mains dans tous les sens, en pointant ses doigts comme s\'il comptait quelque chose, mais ça ne veut rien dire pour vous.%SPEECH_ON%À en jugé par votre expérience, c\'est un bon prix pour la tâche. | Il hoche de la tête. %SPEECH_ON%Vous semblez capable, donc je suis prêt à payer un peu. | Il fait du bruit avec un sac de pièces.%SPEECH_ON%Elles seront votre si vous m\'aidez. | Il ouvre la paume de sa main.%SPEECH_ON%Je suis à sec, donc avant que vous ne demandiez, c\'est tout ce que j\'ai en ce moment. | %SPEECH_ON%Soyez rassuré ce que je vous offre maintenant est un bon prix pour votre travail.} ";				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%Je refuse de payer plus que cela. | %SPEECH_START%Soyez Raisonnable. | %SPEECH_START%Non, non, non. | %SPEECH_START%Qui pensez-vous être? Je vous dit comment vous serez payé. | Il vous regarde sévèrement et secoue la tête.%SPEECH_ON% | %SPEECH_START%Il y a pas moyen!%SPEECH_OFF%Il hurle, explosant de colère.%SPEECH_ON% | %SPEECH_START%Non, vous avez déjà plus que ce que vous valez. | %SPEECH_START%Non. Ne me poussez pas à bout! | %SPEECH_START%Je ne pense pas que vous compreniez comment ça fonctionne. Vous devrez faire avec ce que je veux vous payer pour cela. Mon offre initiale tient toujours. }";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%C\'est bon maintenant? | Il inspire profondement.%SPEECH_ON% | Il soupire.%SPEECH_ON% | %SPEECH_START%C\'est valable. | %SPEECH_START%Bien, bien. | %SPEECH_START%S\'il doit en être ainsi. | %SPEECH_START%Très bien. Que dites-vous de cela? | %SPEECH_START%Bien sûr, bien sûr, je comprend. | %SPEECH_START%Raisonable. | %SPEECH_START%Intéressant. Je pense que cela devrait être plus approprié. | %SPEECH_START%Accepteriez-vous cela plutôt? | %SPEECH_START%Laissez-moi proposer l\'offre suivante. | %SPEECH_ON%Bien. Accepteriez-vous cela plutôt? | %SPEECH_START%Très bien. Compte tenu de votre demande je vous propose cela. | %SPEECH_START%Finissons-en rapidement. Voilà ma nouvelle offre. | %SPEECH_START%On est tous amis ici, n\'est-ce pas ? Voyons voir... }";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_completion% Couronnes quand le travail sera fait.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé} %reward_advance% Courrones d\'avance.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_count% Couronnes par tête que vous ramenez, {pour un maximum de %maxcount% têtes | et je vous paierais pour un maximum de %maxcount% têtes | %maxcount% têtes au maximum}.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_advance% Couronnes d\'avance, et %reward_completion% quand le travail sera fait.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_advance% Couronnes d\'avance, et %reward_count% Couronnes par tête que vous ramenez, {pour un maximum de %maxcount% têtes | et je vous paierais pour un maximum de %maxcount% têtes | %maxcount% têtes au maximum}.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_count% Couronnes par tête que vous ramenez, {pour un maximum de %maxcount% têtes | et je vous paierais pour un maximum de %maxcount% têtes | %maxcount% têtes au maximum}, et encore %reward_completion% quand le travail sera fait.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_advance% Couronnes d\'avance, %reward_count% Couronnes par tête que vous ramenez, {pour un maximum de %maxcount% têtes | et je vous paierais pour un maximum de %maxcount% têtes | %maxcount% têtes au maximum}, et encore %reward_completion% quand le travail sera fait.%SPEECH_OFF%";
			}
			else
			{
				this.Text += " Vous ne serez pas payé. C\'est ce que vous voulez?%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "Négociations",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%Vous agissez comme si vous étiez les seuls à tenir une épée pour des pièces. Je pense que je vais allez regarder autre part pour les hommes dont j\'ai besoin. Bonne journée.%SPEECH_OFF% | %SPEECH_START%Ma patience a ses limites, je pense que je perds mon temps ici.%SPEECH_OFF% | %SPEECH_START%J\'en ai eu assez! Je suis sûr que je trouverais quelqu\'un d\'autre pour faire le travail!%SPEECH_OFF% | %SPEECH_START%N\'insultez pas mon intelligence! Oubliez tout à propos de ce contrat. On en a fini.%SPEECH_OFF% | Sa tête devient rouge de colère.%SPEECH_ON%Sortez d\'ici, je n\'ai pas pour habitude de faire affaire avec des démons cupides!%SPEECH_OFF% | Il soupire. %SPEECH_ON%Juste... Oubliez. Je n\'aurais pas du vous faire confiance en premier lieu. Laissez moi que je puisse trouver d\'autres personnes plus sensible .%SPEECH_OFF% | %SPEECH_START%Je pensais vraiment que nous avions une bonne relation. Mais je sais que je ne peux pousser plus loin. je ne pense pas que ça marchera. Je  m\'en vais.%SPEECH_OFF% | %SPEECH_START%Ça a été une totale perte de temps pour moi. Ne vous embêtez pas à revenir tant que vous n\'aurez pas un minimum de raison.%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "Nous ne risquerons pas nos vies pour une paie si basse...",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "Contract negotiations turned sour");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];
gt.Const.Contracts.NegotiationPerHeadAtDestination <- [
	{
		ID = "Negotiation",
		Title = "Négociations",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "J\'accepte votre offre.",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getInAdvance() + " Couronnes d\'avance");
					}

					if (this.Contract.m.Payment.Count != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getPerCount() + " Couronnes par tête que vous ramenez, jusqu\'à un maximum de " + this.Contract.m.Payment.MaxCount);
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getOnCompletion() + " Couronnes quand le travail sera fait.");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "Nous avons besoin d\'être payés plus pour cela.",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Count < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Count == 0 ? "Nous avons besoin d\'être payés plus par tête que nous ramenons." : "Nous avons besoin d\'être payés plus par tête que nous ramenons.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
							}
							else if (this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Count = this.Math.minf(1.0, this.Contract.m.Payment.Count + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "Nous avons besoin d\'un paiement en avance." : "Nous avons besoin de plus d\'avance.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "Nous avons besoin d\'un paiement une fois le travail accompli." : "Nous avons besoin d\'être payés plus une fois le travail accompli.",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Advance > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}

							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "Oubliez, ça n\'en vaut pas le coup.",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});
			
			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{He nods.%SPEECH_ON%Oui. Hé bien. Je réflèchissais justement à votre paiement pour la tâche un peu plus tôt. | Il se redresse.%SPEECH_ON%Alors, pour le paiement. | Il sourit.%SPEECH_ON%Cela fera de vous un homme riche, mon ami. | Il inspire profondément.%SPEECH_ON%Très bien, c\'est ce que je suis prêt à vous offrir. | Il pose sa main sur votre épaule, en vours souriant.%SPEECH_ON%Je pense avoir une compensation adéquate pour vos services. | Il bouge ses mains dans tous les sens, en pointant ses doigts comme s\'il comptait quelque chose, mais ça ne veut rien dire pour vous.%SPEECH_ON%À en jugé par votre expérience, c\'est un bon prix pour la tâche. | Il hoche de la tête. %SPEECH_ON%Vous semblez capable, donc je suis prêt à payer un peu. | Il fait du bruit avec un sac de pièces.%SPEECH_ON%Elles seront votre si vous m\'aidez. | Il ouvre la paume de sa main.%SPEECH_ON%Je suis à sec, donc avant que vous ne demandiez, c\'est tout ce que j\'ai en ce moment. | %SPEECH_ON%Soyez rassuré ce que je vous offre maintenant est un bon prix pour votre travail.} ";				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%Je refuse de payer plus que cela. | %SPEECH_START%Soyez Raisonnable. | %SPEECH_START%Non, non, non. | %SPEECH_START%Qui pensez-vous être? Je vous dit comment vous serez payé. | Il vous regarde sévèrement et secoue la tête.%SPEECH_ON% | %SPEECH_START%Il y a pas moyen!%SPEECH_OFF%Il hurle, explosant de colère.%SPEECH_ON% | %SPEECH_START%Non, vous avez déjà plus que ce que vous valez. | %SPEECH_START%Non. Ne me poussez pas à bout! | %SPEECH_START%Je ne pense pas que vous compreniez comment ça fonctionne. Vous devrez faire avec ce que je veux vous payer pour cela. Mon offre initiale tient toujours. }";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%C\'est bon maintenant? | Il inspire profondement.%SPEECH_ON% | Il soupire.%SPEECH_ON% | %SPEECH_START%C\'est valable. | %SPEECH_START%Bien, bien. | %SPEECH_START%S\'il doit en être ainsi. | %SPEECH_START%Très bien. Que dites-vous de cela? | %SPEECH_START%Bien sûr, bien sûr, je comprend. | %SPEECH_START%Raisonable. | %SPEECH_START%Intéressant. Je pense que cela devrait être plus approprié. | %SPEECH_START%Accepteriez-vous cela plutôt? | %SPEECH_START%Laissez-moi proposer l\'offre suivante. | %SPEECH_ON%Bien. Accepteriez-vous cela plutôt? | %SPEECH_START%Très bien. Compte tenu de votre demande je vous propose cela. | %SPEECH_START%Finissons-en rapidement. Voilà ma nouvelle offre. | %SPEECH_START%On est tous amis ici, n\'est-ce pas ? Voyons voir... }";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_completion% Couronnez quand le travail est fait.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé} all %reward_advance% Couronnes d\'avance.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_count% Courrones par tête que vous ramenez, {pour un maximum de %maxcount% têtes | et je vous paierais pour un maximum de %maxcount% têtes | %maxcount% têtes au maximum}.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_advance% Couronnes d\'avance, et %reward_completion% quand le travail sera fait.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_advance% Couronnes d\'avance, et %reward_count% crowns per head you arrive with, {pour un maximum de %maxcount% têtes | et je vous paierais pour un maximum de %maxcount% têtes | %maxcount% têtes au maximum}.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_count% Courrones par tête que vous ramenez, {pour un maximum de %maxcount% têtes | et je vous paierais pour un maximum de %maxcount% têtes | %maxcount% têtes au maximum}, et encore %reward_completion% quand le travail sera fait.%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += " {Vous aurez | Vous recevrez | Vous serez payé | C\'est} %reward_advance% Couronnes d\'avance, %reward_count% Courrones par tête que vous ramenez, {pour un maximum de %maxcount% têtes | et je vous paierais pour un maximum de %maxcount% têtes | %maxcount% têtes au maximum}, aet encore %reward_completion% quand le travail sera fait.%SPEECH_OFF%";
			}
			else
			{
				this.Text += " Vous ne serez pas payé. C\'est ce que vous voulez?%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "Négociations",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%Vous agissez comme si vous étiez les seuls à tenir une épée pour des pièces. Je pense que je vais allez regarder autre part pour les hommes dont j\'ai besoin. Bonne journée.%SPEECH_OFF% | %SPEECH_START%Ma patience a ses limites, je pense que je perds mon temps ici.%SPEECH_OFF% | %SPEECH_START%J\'en ai eu assez! Je suis sûr que je trouverais quelqu\'un d\'autre pour faire le travail!%SPEECH_OFF% | %SPEECH_START%N\'insultez pas mon intelligence! Oubliez tout à propos de ce contrat. On en a fini.%SPEECH_OFF% | Sa tête devient rouge de colère.%SPEECH_ON%Sortez d\'ici, je n\'ai pas pour habitude de faire affaire avec des démons cupides!%SPEECH_OFF% | Il soupire. %SPEECH_ON%Juste... Oubliez. Je n\'aurais pas du vous faire confiance en premier lieu. Laissez moi que je puisse trouver d\'autres personnes plus sensible .%SPEECH_OFF% | %SPEECH_START%Je pensais vraiment que nous avions une bonne relation. Mais je sais que je ne peux pousser plus loin. je ne pense pas que ça marchera. Je  m\'en vais.%SPEECH_OFF% | %SPEECH_START%Ça a été une totale perte de temps pour moi. Ne vous embêtez pas à revenir tant que vous n\'aurez pas un minimum de raison.%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "Nous ne pouvons risquer nos vies pour une paie si basse...",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "Contract negotiations turned sour");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];

